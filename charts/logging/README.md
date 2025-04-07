# BendDeploy logging Helm Chart

# BendDeploy logging Helm charts provide the installation of benddeploy logging  for kubernetes.

## Prerequisites
- Kubernetes 1.14+
- Helm v3+

## Installation
To install the chart with release name `logging`:

```bash
helm install logging ./logging --namespace logging --create-namespace
```
Note that you need to override the following parameters in `values.yaml` with your own values.

- `warehouseLogCollector.s3.endpoint`: The endpoint of the s3 storage.
- `warehouseLogCollector.s3.bucket`: The bucket name of the s3 storage.
- `warehouseLogCollector.s3.region`: The region of the s3 storage.
- `warehouseLogCollector.s3.auth.accessKeyId`: The access key of the s3 storage.
- `warehouseLogCollector.s3.auth.secretAccessKey`: The secret key of the s3 storage.

