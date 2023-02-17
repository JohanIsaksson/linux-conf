# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...
# To customize prompt, run  or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
if [ -d ~/.zshrc.d ]; then for zsh in ~/.zshrc.d/*.zsh ; do source "$zsh"; done; fi

POWERLEVEL9K_DISABLE_GITSTATUS=true

. ~/antigen.zsh
antigen bundle zsh-users/zsh-autosuggestions
antigen apply

plugins=(git colored-man-pages)

alias xpwd="pwd | xsel -b"


setxkbmap se
. ~/.p10k.zsh

export PROMPT_COMMAND="pwd > /tmp/whereami"
if [ -f /tmp/whereami ] && [ -s /tmp/whereami ]; then
  cd $(cat /tmp/whereami)
else
  cd ~/projects
fi


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

#. ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# Mount shared folder
if [ -z "$(mount | grep 'vmhgfs-fuse' | grep '/D')" ]; then
  vmhgfs-fuse .host:/D /D -o subtype=vmhgfs-fuse
fi

if [ -z "$(mount | grep 'vmhgfs-fuse' | grep '/P')" ]; then
  vmhgfs-fuse .host:/P /P -o subtype=vmhgfs-fuse
fi

# aliases
. ~/.aliases
. ~/.aliases_sick

