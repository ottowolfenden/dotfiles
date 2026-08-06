if [[ "$TERM" == "linux" || "$TERM_PROGRAM" == "vscode" ]]; then
    ZSH_THEME=""
    PROMPT="%~ > "
else
    if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
        source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
    fi
    ZSH_THEME="powerlevel10k/powerlevel10k"
    [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
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
alias code="code -n"
alias qs="clear; qs |& grep -v 'quickshell.bluetooth.device'"

export MANPATH=/home/otto/.local/share/man:$MANPATH
export PATH=/home/otto/.local/bin:$PATH
export PATH="$PATH:/home/otto/dotfiles/scripts"
export PATH="/usr/local/texlive/2026/bin/x86_64-linux:$PATH"
export MANPATH="/usr/local/texlive/2026/texmf-dist/doc/man:$MANPATH"
export INFOPATH="/usr/local/texlive/2026/texmf-dist/doc/info:$INFOPATH"

if [[ -n "$ZSH_PREFILL" ]]; then
    print -z "$ZSH_PREFILL"
    unset ZSH_PREFILL
fi

source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_STRATEGY=completion
ZSH_AUTOSUGGEST_CLEAR_WIDGETS=(${ZSH_AUTOSUGGEST_CLEAR_WIDGETS:#autosuggest-accept})
ZSH_AUTOSUGGEST_COMPLETION_IGNORE=""

_suggest-after-tab() {
  zle autosuggest-accept
  zle autosuggest-fetch
}

reset-autosuggest-strategy() { 
    ZSH_AUTOSUGGEST_STRATEGY=completion 
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=8"
}

toggle-autosuggest-strategy() {
    if [[ $ZSH_AUTOSUGGEST_STRATEGY == "completion" ]]; then
        ZSH_AUTOSUGGEST_STRATEGY=history
        ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=23"
        zle autosuggest-fetch
    else
        reset-autosuggest-strategy
        zle autosuggest-fetch
    fi
}


add-zsh-hook preexec reset-autosuggest-strategy
zle -N _suggest-after-tab
zle -N toggle-autosuggest-strategy

bindkey ^I _suggest-after-tab
bindkey ^R toggle-autosuggest-strategy