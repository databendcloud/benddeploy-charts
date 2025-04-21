{{- define "common.warehouseLogCollectorConfig" -}}
data_dir: /vector-data-dir
sources:
  otlp:
    type: opentelemetry
    grpc:
      address: 0.0.0.0:4317
    http:
      address: 0.0.0.0:4318
  internal_metrics:
    type: internal_metrics
transforms:
  filter_warehouse_query_logs:
    type: remap
    inputs:
      - otlp.logs
    source: |-
      if (.resources.category != "query") {
        abort
      }
      resources = .resources
      .message = parse_json!(.message)
      .tenant = resources.tenant
      .warehouse = resources.warehouse
      .date = format_timestamp!(now(), "%Y-%m-%d")
      .service = "warehouse"
      .category = "query"
  filter_warehouse_profile_logs:
    type: remap
    inputs:
      - otlp.logs
    source: |-
      if (.resources.category != "profile") {
        abort
      }
      .tenant = .resources.tenant
      .warehouse = .resources.warehouse
      del(.resources)
      .message = parse_json!(.message)
      .query_id = .message.query_id
      .date = format_timestamp!(now(), "%Y-%m-%d")
      .service = "warehouse"
      .category = "profile"
sinks:
  prom_exporter:
    type: prometheus_exporter
    inputs:
      - internal_metrics
    address: 0.0.0.0:9090

  # S3 sink
  s3_warehouse_query_logs:
    type: aws_s3
    inputs:
      - filter_warehouse_query_logs
    endpoint: {{ .Values.warehouseLogCollector.s3.endpoint }}
    bucket: {{ .Values.warehouseLogCollector.s3.bucket }}
    key_prefix: "logs/{{ `{{ tenant }}` }}/query_detail/"
    compression: gzip
    encoding:
      codec: native_json

    # S3 认证配置
    auth:
      access_key_id: {{ .Values.warehouseLogCollector.s3.auth.accessKeyId }}
      secret_access_key: {{ .Values.warehouseLogCollector.s3.auth.secretAccessKey }}

    region: {{ .Values.warehouseLogCollector.s3.region }}

    batch:
      max_bytes: 5242880
      timeout_secs: {{ .Values.warehouseLogCollector.s3.batch.timeoutSecs }}

    filename_time_format: "%Y%m%d-%H%M%S"
    filename_append_uuid: true
  s3_warehouse_profile_logs:
    type: aws_s3
    inputs:
      - filter_warehouse_profile_logs
    endpoint: {{ .Values.warehouseLogCollector.s3.endpoint }}
    bucket: {{ .Values.warehouseLogCollector.s3.bucket }}
    key_prefix: "logs/{{ `{{ tenant }}` }}/profile/"
    compression: gzip
    encoding:
      codec: native_json

    # S3 认证配置
    auth:
      access_key_id: {{ .Values.warehouseLogCollector.s3.auth.accessKeyId }}
      secret_access_key: {{ .Values.warehouseLogCollector.s3.auth.secretAccessKey }}

    region: {{ .Values.warehouseLogCollector.s3.region }}

    batch:
      max_bytes: 5242880
      timeout_secs: {{ .Values.warehouseLogCollector.s3.batch.timeoutSecs }}

    filename_time_format: "%Y%m%d-%H%M%S"
    filename_append_uuid: true
{{- end -}}