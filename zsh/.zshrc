if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(git)

source $ZSH/oh-my-zsh.sh

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
autoload -Uz tetriscurses
brightness-rename() {
    for img in *.(jpg|jpeg|png|webp)(N); do
        if [[ $img =~ '^[0-9]{5}\.' ]]; then
            continue
        fi
        local name=$(magick identify -format "%[fx:int(mean*100000)]" "$img")
        local formatted_name=$(printf "%05d" $name)
        mv -v -n "$img" "${formatted_name}.${img##*.}"
    done
}

alias tetris=tetriscurses
alias suspend="systemctl suspend"
alias code="code -n"

export MANPATH=/home/otto/.local/share/man:$MANPATH
export PATH=/home/otto/.local/bin:$PATH

export PATH="$PATH:/home/otto/dotfiles/scripts"
export PATH="/usr/local/texlive/2026/bin/x86_64-linux:$PATH"
export MANPATH="/usr/local/texlive/2026/texmf-dist/doc/man:$MANPATH"
export INFOPATH="/usr/local/texlive/2026/texmf-dist/doc/info:$INFOPATH"
