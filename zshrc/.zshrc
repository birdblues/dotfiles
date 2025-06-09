# filepath: /Users/birdblues/dotfiles/zshrc/.zshrc
# Powerlevel10k 즉시 프롬프트를 활성화합니다. ~/.zshrc의 최상단에 있어야 합니다.
# 콘솔 입력이 필요할 수 있는 초기화 코드(비밀번호 프롬프트, [y/n]
# 확인 등)는 이 블록 위에 있어야 하며, 그 외의 모든 것은 아래에 있을 수 있습니다.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

install_xterm_kitty_terminfo() {
  # Attempt to get terminfo for xterm-kitty
  if ! infocmp xterm-kitty &>/dev/null; then
    echo "xterm-kitty terminfo not found. Installing..."
    # Create a temp file
    tempfile=$(mktemp)
    # Download the kitty.terminfo file
    # https://github.com/kovidgoyal/kitty/blob/master/terminfo/kitty.terminfo
    if curl -o "$tempfile" https://raw.githubusercontent.com/kovidgoyal/kitty/master/terminfo/kitty.terminfo; then
      echo "Downloaded kitty.terminfo successfully."
      # Compile and install the terminfo entry for my current user
      if tic -x -o ~/.terminfo "$tempfile"; then
        echo "xterm-kitty terminfo installed successfully."
      else
        echo "Failed to compile and install xterm-kitty terminfo."
      fi
    else
      echo "Failed to download kitty.terminfo."
    fi
    # Remove the temporary file
    rm "$tempfile"
  fi
}

install_xterm_wezterm_terminfo() {
  # Attempt to get terminfo for xterm-wezterm
  if ! infocmp wezterm &>/dev/null; then
    echo "wezterm terminfo not found. Installing..."
    # Create a temp file
    tempfile=$(mktemp)
    # Download the wezterm.terminfo file
    # https://github.com/wez/wezterm/blob/main/termwiz/data/wezterm.terminfo
    if curl -o "$tempfile" https://raw.githubusercontent.com/wez/wezterm/main/termwiz/data/wezterm.terminfo; then
      echo "Downloaded wezterm.terminfo successfully."
      # Compile and install the terminfo entry for my current user
      if tic -x -o ~/.terminfo "$tempfile"; then
        echo "wezterm terminfo installed successfully."
      else
        echo "Failed to compile and install wezterm terminfo."
      fi
    else
      echo "Failed to download wezterm.terminfo."
    fi
    # Remove the temporary file
    rm "$tempfile"
  fi
}

install_xterm_kitty_terminfo
install_xterm_wezterm_terminfo

# ===== 유틸리티 함수 =====
# 안전한 소스 로딩 함수
safe_source() {
    [[ -f "$1" ]] && source "$1"
}

# PATH 중복 제거 함수
add_to_path() {
    case ":$PATH:" in
        *":$1:"*) ;;
        *) PATH="$1:$PATH" ;;
    esac
}

# ===== 환경 변수 설정 =====
# PATH 설정 (중복 제거 적용)
add_to_path "/usr/local/bin"
add_to_path "/usr/local/sbin"
add_to_path "$HOME/Library/Android/sdk/platform-tools"
add_to_path "$HOME/Library/Android/sdk/tools/bin"
add_to_path "/Users/birdblues/mosek/10.2/tools/platform/osx64x86/bin"

export NODE_OPTIONS="--max-old-space-size=8192"
export DEFAULT_USER="$USER"

# ===== ZSH 및 테마 설정 =====
export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="powerlevel10k/powerlevel10k"

# 플러그인 (의존성 순서대로 배치)
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting  # 마지막에 로드 (권장사항)
)

source $ZSH/oh-my-zsh.sh

# ===== 에디터 설정 =====
# 동적 경로 검색으로 하드코딩 제거
if command -v nvim &> /dev/null; then
    alias vi="nvim"
    alias vimdiff="nvim -d"
    export EDITOR="$(command -v nvim)"
fi

# ===== 자동완성 설정 =====
# 대소문자 구분 없는 자동완성
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# Docker CLI 자동 완성
fpath=(/Users/birdblues/.docker/completions $fpath)
FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

# compinit 최적화 (중복 실행 방지)
if [[ ! -f ~/.zcompdump || ~/.zshrc -nt ~/.zcompdump ]]; then
    autoload -Uz compinit
    compinit
else
    autoload -Uz compinit
    compinit -C
fi

# ===== 외부 도구 통합 =====
# FZF 통합
safe_source ~/.fzf.zsh

# Powerlevel10k 설정
safe_source ~/.p10k.zsh

# ===== NVM 지연 로딩 =====
# NVM 환경 변수 설정
export NVM_DIR="$HOME/.nvm"

# NVM 지연 로딩 함수
nvm() {
    unset -f nvm node npm
    safe_source "$NVM_DIR/nvm.sh"
    safe_source "$NVM_DIR/bash_completion"
    nvm "$@"
}

# node와 npm도 지연 로딩
node() {
    unset -f nvm node npm
    safe_source "$NVM_DIR/nvm.sh"
    node "$@"
}

npm() {
    unset -f nvm node npm
    safe_source "$NVM_DIR/nvm.sh"
    npm "$@"
}

# ===== GitHub Copilot =====
# 안전한 로딩
if command -v gh &> /dev/null; then
    eval "$(gh copilot alias -- zsh)"
fi

# ===== 터미널 통합 =====
# iTerm2 Shell Integration
safe_source "${HOME}/.iterm2_shell_integration.zsh"

# ===== 주석 처리된 설정 (필요시 활성화) =====
# >>> mamba 초기화 >>>
# !! 이 블록 내의 내용은 'mamba shell init'에 의해 관리됩니다 !!
# export MAMBA_EXE='/opt/anaconda3/condabin/mamba';
# export MAMBA_ROOT_PREFIX='/opt/anaconda3';
# __mamba_setup="$("$MAMBA_EXE" shell hook --shell zsh --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
# if [ $? -eq 0 ]; then
#     eval "$__mamba_setup"
# else
#     alias mamba="$MAMBA_EXE"  # mamba activate의 도움을 받는 대체 방법
# fi
# unset __mamba_setup
# # <<< mamba 초기화 <<<
eval "$(zoxide init zsh)"

# VI Mode!!!
bindkey '^[' vi-cmd-mode

alias la=tree
alias cat=bat

# Eza
alias l="eza -l --icons --git -a"
alias lt="eza --tree --level=2 --long --icons --git"
alias ltree="eza --tree --level=2  --icons --git"

# Lua 5.1 환경 자동 활성화
if [ -f "$HOME/lazy-rocks/bin/activate" ]; then
  source "$HOME/lazy-rocks/bin/activate"
fi

eval "$(rbenv init - zsh)"  # zsh 사용 시

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"
export PATH=$PATH:$(npm config get prefix)/bin
