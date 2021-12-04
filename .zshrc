eval "$(rbenv init -)"
export PATH="$PATH:$HOME/Documents/myscripts"

# https://github.com/asdf-vm/asdf/issues/266
autoload -Uz compinit && compinit

autoload -Uz promptinit && promptinit

autoload -U +X bashcompinit && bashcompinit

autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst
# PROMPT=\$vcs_info_msg_0_'%# '
zstyle ':vcs_info:git:*' formats '(%F{green}%b%f)-(%c%u)'
zstyle ':vcs_info:git:*' check-for-changes true
RPROMPT=\$vcs_info_msg_0_

export AWS_PROFILE=ga-main
export AWS_REGION=ap-northeast-1

complete -C '/usr/local/bin/aws_completer' aws # https://docs.aws.amazon.com/ja_jp/cli/latest/userguide/cli-configure-completion.html
complete -o nospace -C /usr/local/Cellar/tfenv/2.2.2/versions/0.12.28/terraform terraform
complete -o nospace -C /usr/local/Cellar/tfenv/2.2.2/versions/0.13.3/terraform terraform
complete -o nospace -C /usr/local/Cellar/tfenv/2.2.0/versions/0.15.0/terraform terraform
complete -o nospace -C /usr/local/Cellar/tfenv/2.2.2/versions/0.14.10/terraform terraform

# 現在の入力から始まるコマンドの履歴を表示するようにする
[[ -n "${key[PageUp]}" ]] && bindkey "${key[PageUp]}" history-beginning-search-backward
[[ -n "${key[PageDown]}" ]] && bindkey "${key[PageDown]}" history-beginning-search-forward

# alias
# terraform
alias tf='terraform'
alias tff='terraform fmt'
alias tffr='terraform fmt --recursive .'
alias tfi='terraform init'
alias tfp='terraform plan'
alias tfa='terraform apply'
alias tfaa='terraform apply -auto-approve'
alias tfw='terraform workspace'
alias tfwd='terraform workspace delete'
alias tfwn='terraform workspace new'
alias tfwl='terraform workspace list'
alias tfws='terraform workspace select'
alias tfsl='terraform state list'
alias tfsr='terraform state rm'
alias tfsp='terraform state pull'
alias tfsm='terraform state mv'
alias tfss='terraform state show'

# aws_sso_auth
alias aa='aws_sso_ruby auth'
alias aap='aws_sso_ruby auth -p'
function aws_login () {
  export AWS_PROFILE=$1
  aws_sso_ruby auth -p $1
}
export -f aws_login >/dev/null
alias al='aws_login'

# circleci
alias ccv='circleci config validate'
alias celj='circleci execute local --job'

# util
alias zshrc='vim ~/.zshrc'
alias gitconfig='vim ~/.gitconfig'

# git
alias g='git'
alias ga='git a'
alias gaa='git aa'
alias gb='git b'
alias gba='git ba'
alias gbm='git bm'
alias gcom='git com'
alias gcoa='git coa'
alias gcoan='git coan'
alias gch='git ch'
alias gchb='git chb'
alias gf='git f'
alias gi='git i'
alias gcl='git cl'
alias gst='git st'
alias gl='git l'
alias gln='git ln'
alias gd='git d'
alias gdw='git dw'
alias gds='git ds'
alias gdsw='git dsw'
alias gr='git r'
alias gri='git ri'
alias grc='git rc'
alias gra='git ra'
alias gss='git ss'
alias gssk='git ssk'
alias gsp='git sp'
alias gsa='git sa'

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# Added by serverless binary installer
export PATH="$HOME/.serverless/bin:$PATH"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/t_nakahara/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/t_nakahara/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/t_nakahara/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/t_nakahara/Downloads/google-cloud-sdk/completion.zsh.inc'; fi

export HISTFILE=$HOME/.zsh_history
export SAVEHIST=100000
export HISTSIZE=100000
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_DUPS # 重複した履歴を無視
setopt SHARE_HISTORY

export LESS='-R -# 2'
# -, _, /, =, . を削除する
export WORDCHARS=$(echo $WORDCHARS | sed -e 's/-//' -e 's/\///' -e 's/_//' -e 's/=//' -e 's/\.//')
prompt fade blue
# defaults write -g CGFontRenderingFontSmoothingDisabled -bool NO
# defaults -currentHost write -globalDomain AppleFontSmoothing -int 1

DISABLE_AUTO_TITLE="true"
iterm_tab_title() {
  echo -ne "\e]0;${PWD#*${USER}}\a"
}
add-zsh-hook chpwd iterm_tab_title

# peco history
# https://qiita.com/reireias/items/fd96d67ccf1fdffb24ed
function peco-history-selection() {
  BUFFER=$(history -n 1 | tac | awk '!a[$0]++' | peco)
  CURSOR=$#BUFFER
  zle reset-prompt
}
zle -N peco-history-selection
bindkey '^R' peco-history-selection
export PATH=$PATH:/opt/WebDriver/bin
[ -f /usr/local/etc/profile.d/autojump.sh ] && . /usr/local/etc/profile.d/autojump.sh
export PATH="/usr/local/sbin:$PATH"
