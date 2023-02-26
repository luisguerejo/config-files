fpath+=("$(brew --prefix)/share/zsh/site-functions")

autoload -U promptinit; promptinit

PURE_CMD_MAX_EXEC_TIME=10
zstyle :prompt:pure:path color white
zstyle ':prompt:pure:prompt:*' color cyan
zstyle :prompt:pure:git:stash show yes

prompt pure

source /Users/luis/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source /Users/luis/zshrc/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
