#!/bin/bash
BRANCH=${BRANCH:-dev}
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
