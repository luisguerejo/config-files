export PATH=$PATH:/Users/luis/.cargo/bin:/opt/homebrew:/opt/homebrew/bin:/opt/homebrew/Cellar
fpath+=("$(brew --prefix)/share/zsh/site-functions")
autoload -U promptinit; promptinit

PURE_CMD_MAX_EXEC_TIME=10
zstyle :prompt:pure:path color blue
zstyle :prompt:success color cyan
zstyle :prompt:error color yellow
zstyle :prompt:pure:git:stash show yes
prompt pure

source /Users/luis/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source /Users/luis/zshrc/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
echo "~ zsh ~"
date


alias vim=nvim
alias ls=exa
alias grep="grep --color=always"
alias tree="tree -C"
