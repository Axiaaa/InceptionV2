FROM alpine:3.22

ARG BESZEL_VERSION=0.18.4

RUN apk --no-cache add curl

RUN addgroup -S beszel && \
    adduser -S beszel -G beszel

RUN curl -sL "https://github.com/henrygd/beszel/releases/download/v$BESZEL_VERSION/beszel_$(uname -s)_$(uname -m | sed -e 's/x86_64/amd64/' -e 's/armv6l/arm/' -e 's/armv7l/arm/' -e 's/aarch64/arm64/').tar.gz" \
    | tar -xz -O beszel | tee /home/beszel/beszel >/dev/null \
    && chmod +x /home/beszel/beszel

RUN mkdir -p /home/beszel/beszel_data && \
    chown -R beszel:beszel /home/beszel

USER beszel
WORKDIR /home/beszel
CMD ["./beszel", "serve", "--http", "0.0.0.0:8090"]