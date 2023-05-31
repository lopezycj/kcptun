FROM golang:1.20.3-alpine as builder
ENV GO111MODULE=on
ENV GOPROXY=https://goproxy.io,direct
RUN apk update && \
    apk upgrade && \
    apk add git gcc libc-dev linux-headers
RUN go install -ldflags "-X main.VERSION=$(date -u +%Y%m%d) -s -w" github.com/xtaci/kcptun/client@latest && go install -ldflags "-X main.VERSION=$(date -u +%Y%m%d) -s -w" github.com/xtaci/kcptun/server@latest

FROM alpine:3.17
RUN apk add --no-cache iptables
COPY --from=builder /go/bin /bin
RUN mv /bin/server /bin/server_linux_amd64
RUN mv /bin/client /bin/client_linux_amd64
EXPOSE 29900/udp
EXPOSE 12948
