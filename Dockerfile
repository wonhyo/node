FROM alpine:latest
ENV WITH_NODE 1
ENV NODE_VERSION 19.9.0
ENV BUILD_CANVAS 1
RUN set -xe \
    && echo "https://mirror.kku.ac.th/alpine/v3.18/main" > /etc/apk/repositories \
    && echo "https://mirror.kku.ac.th/alpine/v3.18/community" >> /etc/apk/repositories \
    && apk add --no-cache --update git curl \
    && if [ $WITH_NODE -ne 0 ] ; then \
         URL_NODEJS="https://unofficial-builds.nodejs.org/download/release/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64-musl.tar.xz" ; \
         curl -fsSLO --compressed $URL_NODEJS ; \
         tar -xJf "node-v$NODE_VERSION-linux-x64-musl.tar.xz" -C /usr/local --strip-components=1 --no-same-owner ; \
         ln -s /usr/local/bin/node /usr/local/bin/nodejs; \
         rm -f "node-v$NODE_VERSION-linux-x64-musl.tar.xz"; \ 
           if [ $BUILD_CANVAS -ne 0 ] ; then \
             apk add --no-cache --update giflib pango cairo pixman libstdc++ icu icu-data-full ; \
             apk add --no-cache --update --virtual .canvas-deps make gcc g++ python3 python3-dev pixman-dev giflib-dev pango-dev cairo-dev; \
             npm install --global --build-from-source canvas ; \
             apk del .canvas-deps ; \
           fi \
       fi \
    && apk del git curl
