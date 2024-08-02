#!/bin/bash

# dir
mkdir ${HOME}/.config >/dev/null 2>&1
mkdir -p ${HOME}/.local/bin || true
mkdir -p ${HOME}/.local/share || true

# .config
mkdir ${HOME}/.config >/dev/null 2>&1
for item in $(ls ${home_dir}/.config/); do
    rm -rf ${HOME}/.config/${item}
    ln -sf ${home_dir}/.config/${item} ${HOME}/.config/
done

ln -sf $home_dir/.zshrc ~
ln -sf $home_dir/.gitconfig ~
ln -sf $home_dir/.git-credentials ~
ln -sf $home_dir/.npmrc ~
tee >>~/.tmux.conf.local <<EOF
# copy os clipboard
tmux_conf_copy_to_os_clipboard=true

set -gu prefix2
unbind C-a
unbind C-b
set -g prefix M-m
bind M-m send-prefix
# set-option -g default-shell /bin/zsh
EOF
rm -rf ~/.pip
ln -snf $home_dir/.pip ~/.pip
rm -rf ~/.ssh
ln -snf $home_dir/.ssh ~/.ssh
rm -rf ~/.cargo
ln -snf $home_dir/.cargo ~/.cargo
rm -rf ~/.emacs.d
ln -snf $home_dir/.emacs.d ~/.emacs.d

# .local/bin
src_dir="${home_dir}/.local/bin"
dst_dir="${HOME}/.local/bin"
mkdir -p "${dst_dir}" || true
for item in $(ls "${src_dir}"); do
    src_path="${src_dir:?}/${item}"
    dst_path="${dst_dir:?}/${item}"

    rm -rf "$dst_path"
    ln -sf "$src_path" "$dst_path"
done

# zinit
path=".local/share/zinit"
mkdir -p ~/${path} || true
rm -rf ~/${path}/zinit.git
ln -snf "${home_dir}/$path/zinit.git" ~/.local/share/zinit/zinit.git
