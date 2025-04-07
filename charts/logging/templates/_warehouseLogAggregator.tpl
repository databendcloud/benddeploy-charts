{{- define "common.warehouseLogAggregatorConfig" -}}
data_dir: /vector-data-dir
sources:
  vector:
    type: vector
    address: 0.0.0.0:6000
    version: "2"
  internal_metrics:
    type: internal_metrics
transforms:
  filter_warehouse_query_logs:
    type: remap
    inputs:
      - vector
    source: |-
      if (.service != "warehouse") {
        abort
      }
      if (.category != "query") {
        abort
      }
  filter_warehouse_profile_logs:
    type: remap
    inputs:
      - vector
    source: |-
      if (.service != "warehouse") {
        abort
      }
      if (.category != "profile") {
        abort
      }
sinks:
  prom_exporter:
    type: prometheus_exporter
    inputs:
      - internal_metrics
    address: 0.0.0.0:9090
{{- end -}}
