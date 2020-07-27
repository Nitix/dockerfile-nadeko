FROM alpine/git AS git

RUN git clone https://gitlab.com/Kwoth/nadekobot.git /nadekobot/

FROM mcr.microsoft.com/dotnet/core/sdk:3.1-alpine AS build

COPY --from=git /nadekobot /nadekobot

WORKDIR /nadekobot/src/NadekoBot
RUN set -ex; \
    dotnet restore; \
    dotnet build -c Release -o /build/ ; \
    dotnet publish -c Release -o /app

WORKDIR /app
RUN set -ex; \
    rm libopus.so libsodium.dll libsodium.so opus.dll; \
    find . -type f -exec chmod -x {} \;; \
     rm -R runtimes/win* runtimes/osx*
     
FROM mcr.microsoft.com/dotnet/core/runtime:3.1-alpine AS runtime
WORKDIR /app
COPY --from=build /app /app
RUN set -ex; \
    echo '@edge http://dl-cdn.alpinelinux.org/alpine/edge/main' >> /etc/apk/repositories; \
    echo '@edge http://dl-cdn.alpinelinux.org/alpine/edge/community' >> /etc/apk/repositories; \
    apk add --no-cache \
        ffmpeg \
        youtube-dl@edge \
        libsodium \
        opus \
        rsync; \
    adduser -D nadeko; \
    chown nadeko /app; \
    chmod u+w /app; \
    mv /app/data /app/data-default; \
    install -d -o nadeko -g nadeko -m 755 /app/data;

# workaround for the runtime to find the native libs loaded through DllImport
RUN set -ex; \
    ln -s /usr/lib/libopus.so.0 /app/libopus.so; \
    ln -s /usr/lib/libsodium.so.23 /app/libsodium.so

VOLUME [ "/app/data" ]
USER nadeko

COPY docker-entrypoint.sh /
CMD ["/docker-entrypoint.sh"]
