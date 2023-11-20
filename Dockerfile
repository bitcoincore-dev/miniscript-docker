FROM emscripten/emsdk:latest as base
LABEL org.opencontainers.image.source="https://github.com/bitcoincore-dev/miniscript-docker"
LABEL org.opencontainers.image.description="miniscript compiler"
RUN touch updated
RUN echo $(date +%s) > updated
RUN apt-get update
RUN echo $(date +%s) > updated
FROM base as systemd
RUN apt-get install systemd bash jq -y
RUN echo $(date +%s) > updated
RUN chmod +x /usr/bin/systemctl
RUN echo $(date +%s) > updated
FROM systemd as pandoc
RUN apt-get install pandoc -y
RUN echo $(date +%s) > updated
FROM pandoc as docker
RUN apt-get install docker.io -y
RUN echo $(date +%s) > updated
FROM docker as clone
RUN rm -rf /src
RUN git clone --branch v0.0.7 --depth 1 https://github.com/bitcoincore-dev/miniscript-docker /src
RUN echo $(date +%s) > updated
FROM clone as make
WORKDIR /src
RUN make miniscript
RUN echo $(date +%s) > updated
RUN install miniscript /usr/local/bin
RUN echo $(date +%s) > updated
#RUN make miniscript.js ##TODO: better buildx multiplatform building
#RUN echo $(date +%s) > updated
FROM make as install
RUN install ./miniscript /usr/local/bin
RUN echo $(date +%s) > updated
RUN install ./miniscript-* /usr/local/bin
RUN install ./serve /usr/local/bin
RUN echo $(date +%s) > updated
WORKDIR /src
FROM install as miniscript
COPY --from=clone /src /src
ENV PATH=$PATH:/usr/bin/systemctl
RUN ps -p 1 -o comm=
EXPOSE 80 6102 8080 8081
VOLUME /src
