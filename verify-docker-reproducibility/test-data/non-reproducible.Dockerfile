FROM alpine:3.20
RUN echo "built-at: $(date +%s%N)" > /build-timestamp
