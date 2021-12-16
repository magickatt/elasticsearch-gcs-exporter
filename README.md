# Elasticsearch Google Cloud Storage exporter

Using [elasticdump](https://github.com/elasticsearch-dump/elasticsearch-dump) to export indices to Google Cloud Storage using [GCSFuse](https://github.com/GoogleCloudPlatform/gcsfuse).

Example provided as a k8s job for Google Cloud Platform, but could be modified to run otherwise.

## Build

```bash
REGISTRY=us.gcr.io/project-123456/elasticsearch-gcs-exporter
TAG=0.0.1
docker build . --tag=${REGISTRY}:${TAG} --tag ${REGISTRY}:latest
docker push ${REGISTRY}:${TAG}
docker push ${REGISTRY}:latest
```

## Run

Make sure you edit the following values before deploying...

* `image: us.gcr.io/project-123456/elasticsearch-gcs-exporter:latest` (where your image registry is located)
* `--match='^filebeat-.*$'` (which indices you want to exporter)
* `--input=https://elasticsearch.namespace:9200` (where your Elasticsearch cluster is located)
* `command: ["gcsfuse", "request_log_backup-production-private-storage", "/mnt/gcs_bucket"]` (name of the bucket you wish to export to)

```bash
kubectl apply -f job.yaml
```

### Authentication

If you need to include authentication for your Elasticsearch cluster you may need to modify the command used. If may be easier to add a custom entrypoint to the `Dockerfile` and add the `--header` argument that way.

```bash
#!/bin/bash

multielasticdump --direction=dump \
--match='^filebeat-.*$' \
--input=https://elasticsearch.namespace:9200 \
--ignoreType='mapping,settings,template' \
--output=/mnt/gcs_bucket \
--headers '{"Authorization": "Basic YWRtaW46aHVudGVyMg=="}' 
```
