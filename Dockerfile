FROM alpine:latest

ARG LIBRESPOT_VERSION=0.8.0-r0
ARG SNAPCAST_VERSION=0.34.0-r0
ARG SNAPWEB_VERSION=v0.9.2

RUN echo "https://dl-cdn.alpinelinux.org/alpine/edge/testing/" >> /etc/apk/repositories
RUN apk add --no-cache bash snapcast=${SNAPCAST_VERSION} librespot=${LIBRESPOT_VERSION}
RUN wget -O /tmp/snapweb.zip https://github.com/snapcast/snapweb/releases/download/${SNAPWEB_VERSION}/snapweb.zip \
    && unzip -o /tmp/snapweb.zip -d /usr/share/snapserver/snapweb/ \
    && rm /tmp/snapweb.zip

# go-librespot
RUN apk -U --no-cache add libpulse avahi libgcc gcompat alsa-lib python3 \
    && wget -O /tmp/go-librespot.tar.gz https://github.com/devgianlu/go-librespot/releases/download/v0.6.1/go-librespot_linux_x86_64.tar.gz \
    && mkdir  /tmp/go-librespot \
    && tar -xvzf /tmp/go-librespot.tar.gz -C /tmp/go-librespot \
    && mv /tmp/go-librespot/go-librespot /usr/bin/go-librespot \
    && chmod +x /usr/bin/go-librespot \
    && rm -rf /tmp/go-librespot /tmp/go-librespot.tar.gz

# dependencies for go-librespot control script in snapcast
RUN apk -U --no-cache add python3 py3-requests py3-websocket-client

# configs
COPY ./snapserver.conf /usr/etc/snapserver.conf
COPY ./librespot-go.yml /usr/etc/librespot-go/config.yml
COPY ./librespot-go-hq.yml /usr/etc/librespot-go-hq/config.yml

ARG LIBRESPOT_NAME

RUN sed -i -e 's/{{NAME}}/'"${LIBRESPOT_NAME}"'/g' /usr/etc/librespot-go/config.yml \
    && sed -i -e 's/{{NAME}}/'"${LIBRESPOT_NAME}"'/g' /usr/etc/librespot-go-hq/config.yml \
    && sed -i -e 's/{{NAME}}/'"${LIBRESPOT_NAME}"'/g' /usr/etc/snapserver.conf

CMD ["snapserver", "-c", "/usr/etc/snapserver.conf"]

EXPOSE 1704/tcp 1705/tcp 1780
