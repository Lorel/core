FROM golang:1.12.0 AS builder
# ... my go build steps (removed from this example)
WORKDIR /builder/working/directory
RUN curl -L https://github.com/balena-io/qemu/releases/download/v3.0.0%2Bresin/qemu-3.0.0+resin-arm.tar.gz | tar zxvf - -C . && mv qemu-3.0.0+resin-arm/qemu-arm-static .

FROM arm32v7/debian:stretch

# Copy across the qemu binary that was downloaded in the previous build step
COPY --from=builder /builder/working/directory/qemu-arm-static /usr/bin

COPY install/install.sh /tmp/
RUN sh /tmp/install.sh

COPY install/OS_specific/Docker/init.sh /root/
CMD ["sh", "/root/init.sh"]
