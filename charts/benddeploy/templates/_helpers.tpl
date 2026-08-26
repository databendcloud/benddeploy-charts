{{/*
Resolve the benddeploy image reference.

Both forms must keep working, otherwise existing usage breaks:
  1. the map form in values.yaml: {repository: <repo>, tag: <tag>}
  2. a plain string override: --set image=localhost:8080/benddeploy:latest
     (this is what deploy.sh passes)

The template used to be `image: {{ .Values.image }}`, so the map form rendered
as `map[repository:... tag:]`, which is not a valid image reference. That made a
fresh install depend on `--set image=<string>` just to start. This normalizes it.

If repository already carries a tag, the separate tag field is ignored so we
never build something like `repo:latest:v1`.
*/}}
{{- define "benddeploy.image" -}}
{{- if kindIs "string" .Values.image -}}
{{- .Values.image -}}
{{- else -}}
{{- $repo := .Values.image.repository | default "public.ecr.aws/databendlabs/benddeploy" -}}
{{- $tag := .Values.image.tag | default "" -}}
{{- if or (eq $tag "") (contains ":" (base $repo)) -}}
{{- $repo -}}
{{- else -}}
{{- printf "%s:%s" $repo $tag -}}
{{- end -}}
{{- end -}}
{{- end -}}
