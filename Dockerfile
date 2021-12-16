# https://github.com/maciekrb/gcs-fuse-sample

FROM debian:buster-slim
ENV GCSFUSE_REPOSITORY gcsfuse-buster

RUN apt-get update && apt-get install --yes --no-install-recommends \
    ca-certificates \
    curl \
    gnupg \
    && echo "deb http://packages.cloud.google.com/apt $GCSFUSE_REPOSITORY main" \
    | tee /etc/apt/sources.list.d/gcsfuse.list \
    && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - \
    && apt-get update
  
RUN apt-get install --yes \
    gcsfuse \
    npm \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* 

# https://github.com/elasticsearch-dump/elasticsearch-dump/blob/master/Dockerfile

ARG ELASTICDUMP_VERSION=6.34.0
ENV ELASTICDUMP_VERSION=${ELASTICDUMP_VERSION}

ENV NODE_ENV production
RUN npm install elasticdump@${ELASTICDUMP_VERSION} -g

ADD https://raw.githubusercontent.com/elasticsearch-dump/elasticsearch-dump/v${ELASTICDUMP_VERSION}/docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]
