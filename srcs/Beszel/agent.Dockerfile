FROM alpine:3.22

ARG BESZEL_VERSION=0.18.4

RUN apk --no-cache add \
        curl \
        jq \
    && rm -f /var/cache/apk/*

RUN  curl -sL "https://github.com/henrygd/beszel/releases/download/v$BESZEL_VERSION/beszel-agent_$(uname -s)_$(uname -m | sed -e 's/x86_64/amd64/' -e 's/armv6l/arm/' -e 's/armv7l/arm/' -e 's/aarch64/arm64/').tar.gz" | tar -xz beszel-agent

COPY ./init.sh ./init.sh
RUN chmod +x ./init.sh

CMD ["sh", "-c", "./init.sh"]