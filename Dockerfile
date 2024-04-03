FROM alpine:3.18 as prep

RUN apk add --no-cache ca-certificates
RUN adduser \
    --disabled-password \
    --shell "/sbin/nologin" \
    --no-create-home \
    --uid 65532 \
    appuser


FROM scratch
COPY --from=prep /etc/passwd /etc/passwd
COPY --from=prep /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
# TODO: change the binary name when applying this to other projects
COPY lvlcn-t ./

USER appuser
# TODO: change the binary name when applying this to other projects
ENTRYPOINT ["/lvlcn-t"]