FROM ubuntu:20.04
MAINTAINER "Vu Tran<baysao@massbit.io>"
ARG BRANCH=testing
ENV MBR_MODE=docker
ENV MBR_ROLE=gateway
ENV MBR_ENV=$BRANCH
RUN DEBIAN_FRONTEND=noninteractive apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends ca-certificates curl apt-utils git \
    && git clone https://github.com/massbitprotocol/massbitroute_gateway.git /massbit/massbitroute/app/src/sites/services/gateway -b $BRANCH \
&& /massbit/massbitroute/app/src/sites/services/gateway/scripts/run _install \
    ; mkdir -p /var/log/supervisor \
    ; rm -rf /var/lib/apt/lists/* \
    ; echo user=root >>  /etc/supervisor/supervisord.conf
CMD ["/usr/bin/supervisord", "-n"]
