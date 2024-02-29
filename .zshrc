# https://github.com/asdf-vm/asdf/issues/266
autoload -Uz compinit && compinit
autoload -Uz promptinit && promptinit
autoload -U +X bashcompinit && bashcompinit

complete -C '/usr/local/bin/aws_completer' aws # https://docs.aws.amazon.com/ja_jp/cli/latest/userguide/cli-configure-completion.html
complete -o nospace -C /usr/local/Cellar/tfenv/3.0.0/versions/1.3.2/terraform terraform

eval "$(zoxide init zsh)"

export HISTFILE=$HOME/.zsh_history
export SAVEHIST=500000
export HISTSIZE=500000
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_DUPS # 重複した履歴を無視
setopt SHARE_HISTORY
# setopt prompt_cr
# setopt prompt_sp

export LESS='--RAW-CONTROL-CHARS --shift 3 --LONG-PROMPT'
# -, _, /, =, . を削除する
export WORDCHARS=$(echo $WORDCHARS | sed 's/[\-_\/=\.]//g')

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/t_nakahara/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/t_nakahara/Downloads/google-cloud-sdk/path.zsh.inc'; fi
# The next line enables shell command completion for gcloud.
if [ -f '/Users/t_nakahara/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/t_nakahara/Downloads/google-cloud-sdk/completion.zsh.inc'; fi
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

type rbenv >/dev/null 2>&1 && eval "$(rbenv init -)"

autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' formats '(%F{green}%b%f)-(%c%u)'
zstyle ':vcs_info:git:*' check-for-changes true
RPROMPT=\$vcs_info_msg_0_

# set_prompt fire red magenta blue white white magenta
PROMPT='%?>%K{black}%F{green}%D{%H:%M} %B%~%b%f%k '

export AWS_REGION=ap-northeast-1

DISABLE_AUTO_TITLE="true"
iterm_tab_title() {
  echo -ne "\e]0;${PWD#*${USER}}\a"
}
add-zsh-hook chpwd iterm_tab_title

export PATH="/usr/local/sbin:$PATH"
export PATH=$PATH:/opt/WebDriver/bin
export PATH="$PATH:$HOME/Documents/myscripts"
export PATH="$HOME/.serverless/bin:$PATH"
[ -e "$HOME/bin" ] && export PATH="$PATH:$HOME/bin"
[ -d /usr/local/go/bin ] && export PATH="$PATH:/usr/local/go/bin"
[ -d "$HOME/go/bin" ] && export PATH="$PATH:$HOME/go/bin"
[ -e "$HOME/.nodenv/bin" ] && export PATH="$HOME/.nodenv/bin:$PATH"
eval "$(nodenv init -)"

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

# circleci
alias ccv='circleci config validate'
alias cle='circleci local execute --job'

# util
alias zshrc='vim ~/.zshrc && source ~/.zshrc'
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
alias gla='git la'
alias gln='git ln'
alias glp='git lp'
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

alias dcb='docker compose build'
alias dce='docker compose exec'
alias dcr='docker compose run'
alias dcu='docker compose up'
alias dcub='docker compose up --build'

alias cdg='cd $(git rev-parse --show-toplevel)'

alias d='delta_diff'

alias al='source aws_sso_login'
alias ald='aws_sso_login_default'
alias aa='aws_sso_ruby auth'
alias aap='aws_sso_ruby auth -p'


alias gpr='github_pull_request_review'
alias gpa='github_pull_request_approve'
alias gpc='github_pull_request_checkout'
alias ghb='gh browse'
alias ghpc='gh pr create -w'

alias git-pick-commit='fzf --reverse --preview "git show {1} --color=always" --height 50% | awk '\''{print $1}'\'
alias git-pick-from-log='git log --oneline | git-pick-commit'
alias git-pick-from-reflog='git reflog | git-pick-commit'

export TF_CLI_ARGS_plan='-parallelism=40'
export TF_CLI_ARGS_apply='-parallelism=40'

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f /usr/local/etc/profile.d/z.sh ] && source /usr/local/etc/profile.d/z.sh

if type fd > /dev/null 2>&1; then;
  _fzf_compgen_path() {
    fd --hidden --follow --exclude ".git" --exclude ".terraform" . "$1"
  }
  _fzf_compgen_dir() {
    fd --type d --hidden --follow --exclude ".git" --exclude ".terraform" . "$1"
  }
fi

show_snippets() {
    local snippets=$(cat ~/.zsh_snippet | fzf | cut -d':' -f2-)
    LBUFFER="${LBUFFER}${snippets}"
    zle reset-prompt
}
zle -N show_snippets
bindkey '^o' show_snippets

export BAT_THEME=Coldark-Dark

[ -f ~/.zshrc.local ] && source ~/.zshrc.local
