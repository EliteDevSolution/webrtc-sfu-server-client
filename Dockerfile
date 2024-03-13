FROM debian:bookworm-slim

# Install dependencies
RUN apt-get update && \
    apt-get install -y \
        curl \
        build-essential \
        cmake \
        git \
        libssl-dev \
        pkg-config \
        protobuf-compiler \
        xz-utils

# Install Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path

# Install Docker
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
RUN apt-get update && \
    apt-get install -y docker-ce docker-ce-cli containerd.io

WORKDIR /app

COPY . .

RUN cargo build --release

RUN cargo build --package=whipinto --release
RUN cargo build --package=whepfrom --release

FROM debian:bookworm-slim

COPY /app/config-dist.toml /etc/livestream707/config.toml
COPY /app/target/release/livestream707 /usr/local/bin/livestream707

COPY /app/target/release/whipinto /usr/local/bin/whipinto
COPY /app/target/release/whepfrom /usr/local/bin/whepfrom

CMD ["livestream707"]
