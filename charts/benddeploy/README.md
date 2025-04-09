# BendDeploy Helm Chart

## Prerequisites
Kubernetes 1.14+
Helm v3+

## Installation


To install the chart with release name `benddeploy`:
```
helm install benddeploy ./benddeploy --namespace benddeploy --create-namespace --set image=public.ecr.aws/databendlabs/benddeploy:latest
```

Note that for a production cluster, you will likely want to override the following parameters in configmap-benddeploy.yaml with your own values.

- `imageRegistry`： The image registry for the benddeploy image.
- `promEndpoint`: The endpoint of the prometheus server.
- `logCollectorEndpoint`: The endpoint of the log collector.
- `grafanaEndpoint`: The endpoint of the grafana server.
- `db.postgresDSN`: The DSN of the postgres database. if `values.postgres.enabled` is `true`, this value will be ignored.
- `oidcProvider`: The OIDC provider in k8s cluster for authentication.

Then install the chart with release name `benddeploy`:

```
helm upgrade benddeploy ./benddeploy --namespace benddeploy --create-namespace --values values.yaml
```

## Uninstall

To uninstall/delete a Helm release `benddeploy`:

```
helm delete benddeploy --namespace databend
```