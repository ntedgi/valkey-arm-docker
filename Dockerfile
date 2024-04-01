from debian:bookworm-slim as builder

workdir /valkey
copy valkey /valkey
run apt-get update
run apt-get install make gcc pkg-config -y
run rm -rf /var/lib/apt/lists/*
run sed -ri 's!^( *createBoolConfig[(]"protected-mode",.*, *)1( *,.*[)],)$!\10\2!' /valkey/src/config.c
run make install

from debian:bookworm-slim

copy LICENSE /LICENSE
copy --from=builder /usr/local/bin/valkey-* /usr/local/bin/

workdir /data
volume /data
expose 6379
cmd ["/usr/local/bin/valkey-server"]
