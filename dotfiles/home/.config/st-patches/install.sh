#!/bin/bash

[ $(id -u) != "0" ] && { echo "You must be root to run this script"; exit 1; }

script_dir=$(dirname "`readlink -f $0`")

cd ${script_dir}
cd ..
cd st
git reset --hard 0.8.5
git clean -xfd
patch < ${script_dir}/st-anysize-20220718-baa9357.diff
patch < ${script_dir}/st-delkey-20201112-4ef0cbd.diff
patch < ${script_dir}/st-clipboard-0.8.3.diff
patch < ${script_dir}/st-font2-0.8.5.diff
patch < ${script_dir}/st-vertcenter-20180320-6ac8c8a.diff
patch < ${script_dir}/st-desktopentry-0.8.5.diff
patch < ${script_dir}/st-scrollback-0.8.5.diff



sed -i 's|.*static char \*font .*| static char *font = "CodeNewRoman Nerd Font:style=book:pixelsize=15:antialias=true:autohint=true";|' ./config.def.h
sed -i 's|/\*	"Inconsolata for Powerline:pixelsize=12:antialias=true:autohint=true", \*/|"Noto Sans Mono CJK SC:style=Regular:pixelsize=15:antialias=true:autohint=true",|' ./config.def.h
sed -i 's|.*static char \*shell.*| static char *shell = "/bin/zsh";|' ./config.def.h
sed -i 's|float alpha = 0.8;|float alpha = 0.4;|' ./config.def.h
chown x -R ./*
make
make install
