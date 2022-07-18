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
	git config --global --add safe.directory $_dir
	if [ ! -d "$_dir/.git" ]; then
		git clone $_url $_dir -b $_branch

		git -C $_dir fetch --all
		git -C $_dir branch --set-upstream-to=origin/$_branch

	else
		git -C $_dir remote -v | grep 'git@' >/dev/null
		if [ $? -ne 0 ]; then
			git -C $_dir fetch --all
			git -C $_dir pull origin $_branch
		fi
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
		git config --global --add safe.directory $_path
		_url=$(echo $_pathgit | cut -d'|' -f2)
		_branch=$(echo $_pathgit | cut -d'|' -f3)
		if [ -z "$_branch" ]; then _branch=$branch; fi
		if [ ! -d "$_path/.git" ]; then
			git clone $_url $_path -b $_branch
			git -C $_path fetch --all
			git -C $_path branch --set-upstream-to=origin/$_branch
			_is_reload=1
		else

			git -C $_path fetch --all
			git -C $_path checkout $_branch
			tmp="$(git -C $_path pull 2>&1)"

			echo "$tmp" | grep -i "updating"
			st=$?
			echo $_path $st
			if [ $st -eq 0 ]; then
				_is_reload=1
			fi

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
