eval "$(/opt/homebrew/bin/brew shellenv)"

export PATH="$HOME/.local/bin:$PATH"

# 対話しないシェル（エディタや Claude Code など）からも mise のツールを使えるようにする
eval "$(mise activate zsh --shims)"
