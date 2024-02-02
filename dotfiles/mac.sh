#!/bin/sh

dotfiles_dir=$(dirname "`readlink -f $0`")
home_dir=$(dirname "`readlink -f $0`")/home

source ${dotfiles_dir}/common.sh

# 禁止lgoin shell输出提示信息
touch ~/.hushlogin || true
ln -sf ${home_dir}/.mac.zshrc  ~
