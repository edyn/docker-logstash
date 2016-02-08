FROM alpine

ENV LOGSTASH_NAME logstash
ENV LOGSTASH_VERSION 2.2.0
ENV LOGSTASH_URL https://download.elastic.co/$LOGSTASH_NAME/$LOGSTASH_NAME/$LOGSTASH_NAME-$LOGSTASH_VERSION.tar.gz
ENV LOGSTASH_CONFIG /opt/$LOGSTASH_NAME-$LOGSTASH_VERSION/etc/logstash.json

RUN echo '@edge http://nl.alpinelinux.org/alpine/edge/main' >> /etc/apk/repositories \
  && echo '@community http://nl.alpinelinux.org/alpine/edge/community' >> /etc/apk/repositories \
  && echo '@testing http://nl.alpinelinux.org/alpine/edge/testing' >> /etc/apk/repositories \
  && apk update \
  && apk upgrade \
  && apk add \
      bash \
      curl \
      gettext \
      libintl \
      openssl \
      ca-certificates \
      rsync \
  && apk add openjdk8-jre-base@community \
  # Grab envsubst from gettext
  && cp -v /usr/bin/envsubst /bin/ \
  && apk del --purge gettext \
  && mkdir -p /opt \
  && wget -O /tmp/$LOGSTASH_NAME-$LOGSTASH_VERSION.tar.gz $LOGSTASH_URL \
  && tar xzf /tmp/$LOGSTASH_NAME-$LOGSTASH_VERSION.tar.gz -C /opt/ \
  && ln -s /opt/$LOGSTASH_NAME-$LOGSTASH_VERSION /opt/$LOGSTASH_NAME \
  && rm -rf /var/cache/apk/* \
  && mkdir -p /etc/s6/.s6-svscan \
  && ln -s /bin/true /etc/s6/.s6-svscan/finish


COPY root /

ENTRYPOINT ["/bin/s6-svscan","/etc/s6"]
CMD []

EXPOSE 5514 28777 12201
