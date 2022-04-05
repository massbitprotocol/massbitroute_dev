#!/bin/bash
BRANCH=${BRANCH:-dev}

# Required
# export $GIT_PRIVATE_READ_URL

# Options
# export SSL_BRANCH=${SSL_BRANCH:-dev}
# export GWMAN_BRANCH=${GWMAN_BRANCH:-dev}
# export NODE_BRANCH=${NODE_BRANCH:-dev}
# export GATEWAY_BRANCH=${GATEWAY_BRANCH:-dev}
# export STAT_BRANCH=${STAT_BRANCH:-dev}
# export MONITOR_BRANCH=${MONITOR_BRANCH:-dev}
# export API_BRANCH=${API_BRANCH:-dev}
# export SESSION_BRANCH=${SESSION_BRANCH:-dev}
# export GIT_BRANCH=${GIT_BRANCH:-dev}
# export MKAGENT_BRANCH=${MKAGENT_BRANCH:-dev}

if [ -z "$GIT_PRIVATE_READ_URL" ]; then
	echo "Need GIT_PRIVATE_READ_URL"
	exit 1
fi

apt update
apt install -y git
if [ ! -d "/massbit/massbitroute/app/src/.git" ]; then
	git clone https://github.com/massbitprotocol/massbitroute_dev.git /massbit/massbitroute/app/src -b $BRANCH
else
	git -C /massbit/massbitroute/app/src pull origin $BRANCH
fi

git clone $GIT_PRIVATE_READ_URL/massbitroute/env.git /massbit/massbitroute/app/src/env -b $BRANCH

bash -x /massbit/massbitroute/app/src/scripts/run _install
