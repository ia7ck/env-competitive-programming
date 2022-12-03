FROM ubuntu:20.04
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        ca-certificates curl \
        python3 python3-pip \
        build-essential libssl-dev pkg-config \
        vim git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
RUN curl https://sh.rustup.rs | sh -s -- -y

ENV PATH=$PATH:/root/.cargo/bin
# AtCoder の Rust は 1.42.0 https://atcoder.jp/contests/language-test-202001
RUN rustup toolchain install 1.42.0 \
    && rustup update nightly \
    && cargo install cargo-udeps \
    && cargo install cargo-equip

WORKDIR /work
RUN curl -L -o cargo-generate.tar.gz https://github.com/cargo-generate/cargo-generate/releases/download/v0.17.3/cargo-generate-v0.17.3-x86_64-unknown-linux-gnu.tar.gz \
    && tar --extract --file cargo-generate.tar.gz \
    && mv cargo-generate /root/.cargo/bin/ \
    && rm -r ./*
RUN curl -L -o gh.tar.gz https://github.com/cli/cli/releases/download/v2.20.2/gh_2.20.2_linux_amd64.tar.gz \
    && tar xf gh.tar.gz --strip-components 1 \
    && mv bin/gh /usr/local/bin \
    && rm -r ./*
RUN pip3 install --no-cache-dir online-judge-tools

RUN git clone https://github.com/ia7ck/competitive-programming \
    && git clone --branch production https://github.com/atcoder/ac-library
RUN git config --global user.name ia7ck \
    && git config --global user.email 23146842+ia7ck@users.noreply.github.com 
ENV CPLUS_INCLUDE_PATH=/work/ac-library

# https://github.com/rust-lang/rust-analyzer/pull/10457#issuecomment-947915233
# RUN ln -s "$(rustc --print sysroot)"/lib/rustlib/src/rust/src "$(rustc --print sysroot)"/lib/rustlib/src/rust/library
