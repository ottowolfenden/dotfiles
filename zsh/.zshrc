if [[ "$TERM" == "linux" || "$TERM_PROGRAM" == "vscode" ]]; then
    ZSH_THEME=""
    PROMPT="%~ > "
else
    [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]] &&
        source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
    ZSH_THEME="powerlevel10k/powerlevel10k"
    [[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
fi

export ZSH="$HOME/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh

autoload -Uz tetriscurses
autoload -U add-zsh-hook

clearscreen() {
    printf '\033[3J'
    zle clear-screen
}
zle -N clearscreen
bindkey '^L' clearscreen

zle_highlight+=(paste:none)

alias tetris=tetriscurses
alias suspend="systemctl suspend"
alias qs="clear; qs |& grep -v 'quickshell.bluetooth.device'"

export MANPATH=/home/otto/.local/share/man:$MANPATH
export PATH=/home/otto/.local/bin:$PATH
export PATH="$PATH:/home/otto/dotfiles/scripts"
export PATH="/usr/local/texlive/2026/bin/x86_64-linux:$PATH"
export MANPATH="/usr/local/texlive/2026/texmf-dist/doc/man:$MANPATH"
export INFOPATH="/usr/local/texlive/2026/texmf-dist/doc/info:$INFOPATH"

[[ -n "$ZSH_PREFILL//" ]] && {
    print -z "$ZSH_PREFILL"
    unset ZSH_PREFILL
}

source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_STRATEGY=completion

_suggest-after-tab() {
    zle autosuggest-accept
    zle autosuggest-fetch
}

zle -N _suggest-after-tab

bindkey ^I _suggest-after-tab

[ -f "/home/otto/.ghcup/env" ] && . "/home/otto/.ghcup/env"

texshow() {
    for s in "$@"; do
        local tmp=$(mktemp --suffix=.tex)
        printf '%s' \
            "\\documentclass{article}\\usepackage{amssymb,amsthm,mathtools}\\begin{document}\\show$s\\end{document}" \
            > "$tmp"
        lualatex --output-directory=/tmp -halt-on-error "$tmp" | 
            sed -n '/^> /,/^l\.1 /p' | 
            sed '$d'
        rm -f "$tmp" "${tmp%.tex}.aux" "${tmp%.tex}.log"
    done
}

yt-playlist-download() {
    yt-dlp \
        -t mp3 \
        --no-sponsorblock \
        --embed-thumbnail \
        "$1"
}

node-with() { node -i -e "Object.assign(globalThis, require('./$1'))"; }