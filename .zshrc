# https://github.com/asdf-vm/asdf/issues/266
autoload -Uz compinit && compinit
autoload -Uz promptinit && promptinit
autoload -U +X bashcompinit && bashcompinit

complete -C '/usr/local/bin/aws_completer' aws # https://docs.aws.amazon.com/ja_jp/cli/latest/userguide/cli-configure-completion.html
complete -o nospace -C /usr/local/Cellar/tfenv/3.0.0/versions/1.3.2/terraform terraform

export HISTFILE=$HOME/.zsh_history
export SAVEHIST=100000
export HISTSIZE=100000
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

eval "$(rbenv init -)"

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
alias celj='circleci execute local --job'

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

function diff_delta() {
  argv=($@);
  diff -u $1 $2 | delta ${argv:3:$(($# - 1))}
}

function diff_r_delta() {
  argv=($@);
  diff -ur --exclude='.git' --exclude='.terraform' $1 $2 | delta ${argv:3:$(($# - 1))}
}
export diff_delta >/dev/null
export diff_r_delta >/dev/null
alias d='diff_delta'
alias dr='diff_r_delta'

# aws_sso_auth
function aws_login () {
  export AWS_PROFILE=$1

  REGION=$(aws configure get sso_region --profile $1)
  ACCOUNT_ID=$(aws configure get sso_account_id --profile $1)
  ROLE_NAME=$(aws configure get sso_role_name --profile $1)

  if [ -d ~/.aws/sso/cache ]; then
    ACCESS_TOKEN=$(grep -l accessToken ~/.aws/sso/cache/* |
        xargs jq -r ".accessToken")
  fi

  cred=$(aws sso get-role-credentials \
    --account-id ${ACCOUNT_ID} \
    --role-name ${ROLE_NAME} \
    --access-token ${ACCESS_TOKEN} \
    --region ${REGION} \
    --query roleCredentials);

  if [ $? -ne 0 ]; then
    aws sso login
    ACCESS_TOKEN=$(grep -l accessToken ~/.aws/sso/cache/* |
        xargs jq -r ".accessToken")

    cred=$(aws sso get-role-credentials \
      --account-id ${ACCOUNT_ID} \
      --role-name ${ROLE_NAME} \
      --access-token ${ACCESS_TOKEN} \
      --region ${REGION} \
      --query roleCredentials);
  fi

  aws configure set aws_secret_access_key $(echo ${cred} | jq -r '.secretAccessKey') --profile $1
  aws configure set aws_access_key_id $(echo ${cred} | jq  -r '.accessKeyId') --profile $1
  aws configure set aws_session_token $(echo ${cred} | jq -r '.sessionToken') --profile $1
  # aws_sso_ruby auth -p $1
}
export aws_login >/dev/null
alias al='aws_login'
alias aa='aws_sso_ruby auth'
alias aap='aws_sso_ruby auth -p'

function aws_login_default {
  profile=$1
  account_id=$(aws configure get sso_account_id --profile $profile)
  role=$(aws configure get sso_role_name --profile $profile)
  key=$(aws configure get aws_secret_access_key --profile $profile)
  key_id=$(aws configure get aws_access_key_id --profile $profile)
  token=$(aws configure get aws_session_token  --profile $profile)

  aws configure set sso_account_id $account_id --profile default
  aws configure set sso_role_name $role --profile default
  aws configure set aws_secret_access_key $role --profile default
  aws configure set aws_access_key_id $key_id --profile default
  aws configure set aws_session_token $token --profile default
}

export aws_login_default >/dev/null
alias ald='aws_login_default'

function github_pr_review {
  pr_url=$1
  gh pr edit \
    --remove-assignee '@me' \
    --add-assignee $(gh pr view $pr_url --json author | jq -r '.author.login') \
    $pr_url
}
export github_pr_review  >/dev/null
alias gpr='github_pr_review'

function github_pr_approve {
  pr_url=$1
  gh pr review -a $pr_url
  gh pr edit \
    --remove-assignee '@me' \
    --add-assignee $(gh pr view $pr_url --json author | jq -r '.author.login') \
    $pr_url
}
export github_pr_approve >/dev/null
alias gpa='github_pr_approve'

function github_pr_checkout {
  gh pr list \
    --json author,number,title \
    --template '{{range .}}{{tablerow .number .author.login .title}}{{end}}' |
    fzf --height 12 |
    awk '{print $1}' |
    xargs gh pr checkout
}
export github_pr_checkout >/dev/null
alias gpc='github_pr_checkout'

function exec_command {
  cluster=$(
    aws ecs list-clusters |
      jq -r '.clusterArns[]' |
      awk -F '/' '{ print $2 }' |
      fzf --height 5
  )
  task=$(
    aws ecs list-tasks --cluster $cluster |
      jq -r '.taskArns[]' |
      fzf --height 5
  )
  aws ecs execute-command \
    --command /bin/bash \
    --interactive \
    --cluster $cluster \
    --task $task
}

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

function jump_directory_moved_recentry() {
  dest=$(z -l | awk '{ print $2 }' | fzf --layout=reverse --height=20%)
  if [ -z "${dest}" ]; then
    return
  fi

  cd ${dest}
}
alias c='jump_directory_moved_recentry'
