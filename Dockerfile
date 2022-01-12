FROM golang:alpine as builder

RUN apk add --no-cache git build-base && \
    apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/v3.12/main zfs-dev=0.8.4-r0

WORKDIR /zfs-exporter

COPY zfs-exporter/go.mod .
COPY zfs-exporter/go.sum .

RUN go mod download

COPY zfs-exporter/ .

RUN go build -ldflags="-s -w" .

FROM alpine

RUN apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/v3.12/main zfs-libs=0.8.4-r0

COPY --from=builder /zfs-exporter/zfs-exporter /usr/local/bin

USER root

ENTRYPOINT /usr/local/bin/zfs-exporter

EXPOSE 9254
