#!/bin/bash
SITE_ROOT=$(realpath $(dirname $(realpath $0))/..)

_git_config() {
	# if [ ! -f "$HOME/.gitconfig" ]; then
	cat >$HOME/.gitconfig <<EOF
   [http]
        sslverify = false
    [user]
	email = baysao@gmail.com
	name = Baysao
EOF
	# fi

}
_git_clone() {
	_url=$1
	_dir=$2
	_branch=$3
	if [ -z "$_branch" ]; then _branch=$MBR_ENV; fi
	# if [ -d "$_dir" ]; then rm -rf $_dir; fi
	mkdir -p $_dir
	if [ ! -d "$_dir/.git" ]; then
		git clone $_url $_dir -b $_branch
		git -C $_dir branch --set-upstream-to=origin/$_branch
	else
		git -C $_dir pull origin $_branch
	fi
	if [ -f "$_dir/scripts/run" ]; then
		echo "========================="
		echo "$_dir/scripts/run _prepare"
		echo "========================="
		$_dir/scripts/run _prepare
	fi

}

_update_sources() {
	_git_config
	_is_reload=0
	branch=$MBR_ENV
	for _pathgit in $@; do
		_path=$(echo $_pathgit | cut -d'|' -f1)
		tmp="$(timeout 60 git -C $_path pull origin $branch 2>&1)"
		echo "$tmp"
		echo "$tmp" | grep -i "error"
		if [ $? -eq 0 ]; then
			timeout 60 git -C $_path reset --hard
			tmp="$(timeout 60 git -C $_path pull origin $branch 2>&1)"
		fi

		echo "$tmp" | grep -i "updating"
		st=$?
		echo $_path $st
		if [ $st -eq 0 ]; then
			_is_reload=1
		fi

	done
	return $_is_reload
}
loop() {
	while true; do
		$0 $@
		sleep 3
	done

}
_timeout() {
	t=$1
	if [ -n "$t" ]; then
		shift
		timeout $t $0 $@
	else
		$0 $@
	fi
}
