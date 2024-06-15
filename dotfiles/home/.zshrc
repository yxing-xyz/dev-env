TRZSZ_ENABLE=trzsz
OMZTHEME=OMZT::robbyrussell
# OMZTHEME=OMZT::eastwood
# OMZTHEME=OMZT::garyblessington
# 历史纪录条目数量
export HISTSIZE=10000000
# 注销后保存的历史纪录条目数量
export SAVEHIST=10000000

export LANG=en_US.UTF-8
# export LC_ALL=C
export LC_CTYPE=en_US.UTF-8

export FZF_DEFAULT_OPTS='--no-mouse --height 50% --reverse --multi --inline-info --preview "bat --style=numbers --color=always --line-range :500 {} 2> /dev/null"'
# export FZF_DEFAULT_COMMAND='fd --hidden --follow --exclude ".git" 2> /dev/null'
export FZF_ALT_C_COMMAND='fd -t d --follow 2> /dev/null'
# file
export FZF_CTRL_T_COMMAND="fd --follow --exclude ".git" 2> /dev/null"

# emacs
export EDITOR='emacsclient -t'

# PATH
case ":${PATH}:" in
*:"$HOME/.cargo/bin":*) ;;
*)
    if [[ "${OSTYPE}" == darwin* ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
        export HOMEBREW_NO_AUTO_UPDATE=1
        export HOMEBREW_INSTALL_FROM_API=1

        export HOMEBREW_API_DOMAIN="https://mirror.nju.edu.cn/homebrew-bottles/api"
        export HOMEBREW_BOTTLE_DOMAIN="https://mirror.nju.edu.cn/homebrew-bottles"

        export HOMEBREW_BREW_GIT_REMOTE="https://mirror.nju.edu.cn/git/homebrew/brew.git"
        export HOMEBREW_CORE_GIT_REMOTE="https://mirror.nju.edu.cn/git/homebrew/homebrew-core.git"
        export HOMEBREW_PIP_INDEX_URL="https://mirrors.nju.edu.cn/pypi/web/simple"
        export DOCKER_HOST=unix:///Users/x/.docker/run/docker.sock
    fi
    export PATH=$HOME/.local/bin:$PATH
    export PATH=$HOME/.cargo/bin:$PATH
    export PATH=$HOME/go/bin:$PATH
    ;;
esac

cheat.sh() {
    curl -L cheat.sh/$1
}

shutdownAfter() {
    while [ true ]; do
        pgrep $1 >/dev/null 2>&1
        if (($? != 0)); then
            break
        fi
        sleep 300
    done
    shutdown -h now
}

setProxy() {
    case $1 in
    start)
        PROXY_SERVER="127.0.0.1:12333" # define your proxy server here
        echo "setting proxy..."
        export http_proxy="http://$PROXY_SERVER"
        export https_proxy="http://$PROXY_SERVER"
        export ftp_proxy="ftp://$PROXY_SERVER"
        export HTTP_PROXY=$http_proxy
        export HTTPS_PROXY=$https_proxy
        export FTP_PROXY=$ftp_proxy
        export all_proxy=$http_proxy
        export NO_PROXY=localhost,192.168.*,10.*,127.0.*
        ;;
    stop)
        echo "stopping proxy..."
        unset http_proxy
        unset https_proxy
        unset ftp_proxy
        unset HTTP_PROXY
        unset HTTPS_PROXY
        unset FTP_PROXY
        unset all_proxy
        unset NO_PROXY
        ;;
    status)
        echo "http_proxy=$http_proxy"
        echo "HTTP_PROXY=$HTTP_PROXY"
        echo "https_proxy=$https_proxy"
        echo "HTTPS_PROXY=$HTTPS_PROXY"
        echo "ftp_proxy=$ftp_proxy"
        echo "FTP_PROXY=$FTP_PROXY"
        echo "all_proxy=$all_proxy"
        echo "NO_PROXY=$NO_PROXY"
        ;;
    esac
}

typeset -A ZINIT
ZINIT[NO_ALIASES]=1
source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
# # 快速跳转
eval "$(zoxide init zsh)"
zinit snippet OMZ::plugins/svn # svn
zinit snippet OMZ::lib/git.zsh # git
zinit snippet OMZ::lib/async_prompt.zsh
zinit snippet OMZ::lib/history.zsh
zinit snippet OMZ::lib/key-bindings.zsh
zinit snippet OMZ::lib/clipboard.zsh # 剪剪切板

zinit snippet OMZ::plugins/colored-man-pages/colored-man-pages.plugin.zsh
zinit snippet OMZ::plugins/extract # 后缀解压

zinit snippet OMZ::lib/completion.zsh

# # 快速语法高亮
zinit wait lucid for \
    atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
    zdharma-continuum/fast-syntax-highlighting \
    blockf \
    zsh-users/zsh-completions \
    atload"!_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions

zinit snippet OMZ::lib/theme-and-appearance.zsh
zinit snippet ${OMZTHEME}

# 按键
bindkey -d
# zsh clip to xorg clipboard
if [[ -n $DISPLAY ]] || [[ "${OSTYPE}" == darwin* ]]; then
    x-copy-region-as-kill() {
        zle copy-region-as-kill
        print -rn $CUTBUFFER | clipcopy
    }
    zle -N x-copy-region-as-kill

    x-kill-region() {
        if (($REGION_ACTIVE == 1)); then
            zle copy-region-as-kill
            print -rn $CUTBUFFER | clipcopy
            zle kill-region
        else
            zle backward-kill-word
            print -rn $CUTBUFFER | clipcopy
        fi
    }
    zle -N x-kill-region

    x-yank() {
        CUTBUFFER=$(clippaste)
        zle yank
    }
    zle -N x-yank

    x-kill-line() {
        zle kill-line
        print -rn -- "$CUTBUFFER" | clipcopy
    }
    zle -N x-kill-line

    bindkey -e '\ew' x-copy-region-as-kill
    bindkey -e '^W' x-kill-region
    bindkey -e '^Y' x-yank
    bindkey -e '\C-k' x-kill-line
fi
x-input-current-path() {
    CUTBUFFER=$(pwd)
    zle yank
}
zle -N x-input-current-path
bindkey -e '^[\' x-input-current-path

x-input-empty-dir() {
    CUTBUFFER='rm -rf ./*'
    zle yank
}
zle -N x-input-empty-dir
bindkey -e '^[`' x-input-empty-dir

x-backward-delete-char() {
    if (($REGION_ACTIVE == 1)); then
        zle kill-region
    else
        zle backward-delete-char
    fi
}
zle -N x-backward-delete-char

x-delete-char() {
    if (($REGION_ACTIVE == 1)); then
        zle kill-region
    else
        zle delete-char
    fi
}
zle -N x-delete-char

bindkey -e '^?' x-backward-delete-char
bindkey -e '^[[3~' x-delete-char
bindkey -e '^x^e' edit-command-line

# FZF
source <(fzf --zsh)
bindkey -e '^S' fzf-history-widget
bindkey -e '\e[' fzf-file-widget
bindkey -e '\e]' fzf-cd-widget

# 还原emacs快捷键
bindkey -e '\el' down-case-word
bindkey -s '\e^M' 'ls -lh\n'
bindkey -e '\ec' capitalize-word
bindkey -e '^T' transpose-chars

# alias
alias rm='trash-put'
alias ls='lsd'
alias cat="bat"
alias diff="difft --display inline"
alias lzg='lazygit'
alias ect='emacsclient -t'
alias ecc='emacsclient -c'
alias eq='emacs -nw -q'
alias bj="sshuttle --dns -vr root@60.205.202.6   10.0.0.0/8 172.16.0.0/12  --ssh-cmd \"ssh -i /home/x/.ssh//品牌中心.key\""
alias hz="sshuttle --dns -vr root@112.124.55.199 10.0.0.0/8 192.168.0.0/16 --ssh-cmd \"ssh -i /home/x/.ssh/品牌中心.key\""
alias ssh="TERM=xterm-256color ${TRZSZ_ENABLE} ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"
alias docker="TERM=xterm-256color ${TRZSZ_ENABLE} docker"
alias lzd="${TRZSZ_ENABLE} lazydocker"
alias k9s="${TRZSZ_ENABLE} k9s"
# 只有alacritty环境才启动zellij
if [ ! -z ${ALACRITTY_LOG+x} ]; then
    ZELLIJ_AUTO_ATTACH=true
    if [[ -z "$ZELLIJ" ]]; then
        if [[ "$ZELLIJ_AUTO_ATTACH" == "true" ]]; then
            zellij attach -c
        else
            zellij
        fi

        if [[ "$ZELLIJ_AUTO_EXIT" == "true" ]]; then
            exit
        fi
    fi
fi
eval "$(vfox activate zsh)"
