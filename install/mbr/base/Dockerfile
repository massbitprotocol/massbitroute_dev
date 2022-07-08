FROM ubuntu:20.04
MAINTAINER "Vu Tran<baysao@massbit.io>"

ARG BRANCH="testing"
ARG GIT_PRIVATE_READ_URL="https://github.com"

ENV MBR_ENV=${BRANCH} MBR_MODE=docker DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    supervisor ca-certificates curl rsync apt-utils git python3 python3-pip parallel apache2-utils jq python-is-python2 libssl-dev libmaxminddb-dev fcgiwrap cron xz-utils liburcu-dev libev-dev libsodium-dev libtool libunwind-dev libmaxminddb-dev \
    ; mkdir -p /var/log/supervisor \
    ; rm -rf /var/lib/apt/lists/* \
   ; sed '/\[supervisord/a user=root\nusername=dummy\npassword=dummy\nloglevel=error' -i /etc/supervisor/supervisord.conf \
    ; sed '/\[unix_http_server/a user=root\nusername=dummy\npassword=dummy\nloglevel=error' -i /etc/supervisor/supervisord.conf \
    ; sed '/\[supervisorctl/a user=root\nusername=dummy\npassword=dummy\nloglevel=error' -i /etc/supervisor/supervisord.conf


ADD . /massbit/massbitroute/app/src/sites/services/api
RUN bash -x /massbit/massbitroute/app/src/sites/services/api/scripts/run _install

CMD ["-n"]
ENTRYPOINT  ["/usr/bin/supervisord"]
