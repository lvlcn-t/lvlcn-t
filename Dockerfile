FROM golang:1.21-alpine3.18 AS builder

ARG PRIVATE_GO_SERVER
ARG CI_USER='__token__'
ARG CI_JOB_TOKEN

ENV GOPRIVATE "$PRIVATE_GO_SERVER/*"
RUN echo "machine $PRIVATE_GO_SERVER" >> ~/.netrc &&\
    echo "    login $CI_USER" >> ~/.netrc &&\
    echo "    password $CI_JOB_TOKEN" >> ~/.netrc

RUN apk add --no-cache git

COPY . /tmp/app

WORKDIR /tmp/app

RUN go mod download

RUN go build -o bin/app -ldflags="-s -w" ./cmd/app/main.go

FROM alpine:3.18

ARG user_id=1000
RUN adduser -S $user_id -G root -u $user_id

COPY --from=builder --chown=$user_id:root /tmp/app/bin/app /app/application

EXPOSE 8080

USER $user_id

CMD ["/app/application"]