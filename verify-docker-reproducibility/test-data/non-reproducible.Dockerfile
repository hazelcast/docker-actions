FROM alpine:latest
RUN echo "built-at: $(date +%s%N)" > /build-timestamp \
  && sleep 1
USER nobody
