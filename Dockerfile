FROM emscripten/emsdk:latest as base
LABEL org.opencontainers.image.source="https://github.com/bitcoincore-dev/miniscript-docker"
LABEL org.opencontainers.image.description="miniscript compiler"
RUN touch updated
RUN echo $(date +%s) > updated
RUN apt-get update
RUN echo $(date +%s) > updated
FROM base as systemd
RUN apt-get install systemd -y
RUN chmod +x /usr/bin/systemctl
RUN echo $(date +%s) > updated
FROM systemd as clone
WORKDIR /tmp
RUN git clone --recurse-submodules -j2 --branch v0.0.10 --depth 1 https://github.com/bitcoincore-dev/miniscript-docker
RUN echo $(date +%s) > updated
FROM clone as make
WORKDIR /tmp/miniscript-docker
RUN make miniscript
RUN echo $(date +%s) > updated
RUN install miniscript /usr/local/bin
RUN echo $(date +%s) > updated
#RUN make miniscript.js ##TODO: better buildx multiplatform building
#RUN echo $(date +%s) > updated
FROM make as install
RUN install ./miniscript /usr/local/bin
RUN echo $(date +%s) > updated
RUN install ./miniscript-** /usr/local/bin
RUN install ./serve /usr/local/bin
RUN echo $(date +%s) > updated
WORKDIR /src
FROM install as miniscript
COPY --from=clone /src /src
FROM miniscript as bdk_cli
RUN apt-get install cargo -y
RUN apt-get clean autoclean
RUN apt-get autoremove --yes
RUN rm -rf /var/lib/{apt,dpkg,cache,log}/
RUN cargo install --git https://github.com/bitcoindevkit/bdk-cli --features="compiler"
ENV PATH=$PATH:/usr/bin/systemctl
RUN ps -p 1 -o comm=
EXPOSE 80 443 6102 8080 8081
VOLUME /src
