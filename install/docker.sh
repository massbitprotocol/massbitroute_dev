#!/bin/bash
if [ $# -eq 0 ]; then
	echo "$0 build|up dev|prod BRANCH VER"
	exit 1
fi

env=$1
bran=$2
ver=$3
shift 3
_f=./mbr/run/docker-compose-$ver-$bran-$env.yml
sed "s/_BRANCH_/$bran/g" ./mbr/docker-compose-$env.yml >$_f
sed "s/_VER_/$ver/g" -i $_f
sed "s/_ENV_/$env/g" -i $_f
cat $_f
echo docker-compose -f $_f $@
docker-compose -f $_f $@

#./docker.sh dev shamu 0.0.1 build api
#./docker.sh dev shamu 0.0.1 build git
#./docker.sh dev shamu 0.0.1 build stat
#./docker.sh dev shamu 0.0.1 build monitor

#./docker.sh dev shamu 0.0.1 build node
#./docker.sh dev shamu 0.0.1 build gateway
