FROM debian:sid-slim AS common

RUN apt update -y && apt install -y --no-install-recommends ca-certificates

RUN apt install -y --no-install-recommends libglib2.0-dev libssl-dev \

FROM common AS builder

# Now, rust version: 1.70
RUN apt install -y --no-install-recommends cargo cargo-c

WORKDIR /app

COPY . .

RUN cargo build --release

RUN cargo build --package=whipinto --release
RUN cargo build --package=whepfrom --release

FROM common

COPY --from=builder /app/config-dist.toml /etc/livestream707/config.toml
COPY --from=builder /app/target/release/livestream707 /usr/local/bin/livestream707

COPY --from=builder /app/target/release/whipinto /usr/local/bin/whipinto
COPY --from=builder /app/target/release/whepfrom /usr/local/bin/whepfrom

CMD ["livestream707"]
