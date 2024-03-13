FROM debian:sid-slim AS common

RUN apt update -y && apt install -y --no-install-recommends ca-certificates

RUN apt install -y --no-install-recommends libglib2.0-dev libssl-dev \
    libgstreamer1.0-dev gstreamer1.0-tools gstreamer1.0-libav \
    libgstreamer-plugins-base1.0-dev gstreamer1.0-plugins-base \
    gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly \
    libpango1.0-dev libgstreamer-plugins-bad1.0-dev gstreamer1.0-nice


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
