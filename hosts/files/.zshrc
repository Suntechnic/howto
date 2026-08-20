# Настройка плагинов для zsh
ZSH_PLUGINS_DIR="$HOME/.config/zsh/plugins"
ZSH_PLUGINS_UPDATE_FILE="$HOME/.cache/zsh/plugins-last-update"
ZSH_PLUGINS_UPDATE_INTERVAL=604800

typeset -a lstZshPluginNames
lstZshPluginNames=(
    zsh-autosuggestions
    zsh-syntax-highlighting
)

zsh-plugin-clone () {
    local PluginName="$1"
    local PluginDir="$ZSH_PLUGINS_DIR/$PluginName"

    print -n -P "%F{yellow}↻ zsh:%f установка %F{cyan}$PluginName%f... "

    if git clone --depth 1 \
        "https://github.com/zsh-users/$PluginName.git" \
        "$PluginDir"; then
        print -P "%F{green}готово%f"

        return 0
    fi

    print -P "%F{red}ошибка%f"

    return 1
}

zsh-plugin-update () {
    local PluginName="$1"
    local PluginDir="$ZSH_PLUGINS_DIR/$PluginName"
    local UpdateOutput
    local ExitCode

    UpdateOutput="$(git -C "$PluginDir" pull --ff-only --quiet 2>&1)"
    ExitCode=$?

    if (( ExitCode != 0 )); then
        print -u2 -P "%F{red}✗ zsh:%f не удалось обновить %F{yellow}$PluginName%f"
        print -u2 -- "$UpdateOutput"

        return 1
    fi

    if [[ "$UpdateOutput" == *'Already up to date.'* ]]; then
        print -P "%F{242}· zsh:%f $PluginName — актуален"
    else
        print -P "%F{green}✓ zsh:%f обновлён %F{cyan}$PluginName%f"
    fi

    return 0
}

mkdir -p "$ZSH_PLUGINS_DIR" "${ZSH_PLUGINS_UPDATE_FILE:h}"

for PluginName in "${lstZshPluginNames[@]}"; do
    PluginDir="$ZSH_PLUGINS_DIR/$PluginName"

    if [[ ! -d "$PluginDir/.git" ]]; then
        zsh-plugin-clone "$PluginName"
    fi
done

if [[ ! -f "$ZSH_PLUGINS_UPDATE_FILE" ]] || \
    (( $(date +%s) - $(stat -c %Y "$ZSH_PLUGINS_UPDATE_FILE") >= ZSH_PLUGINS_UPDATE_INTERVAL )); then

    print -P "%F{yellow}↻ zsh:%f проверка обновлений плагинов"
    UpdateFailed=0

    for PluginName in "${lstZshPluginNames[@]}"; do
        PluginDir="$ZSH_PLUGINS_DIR/$PluginName"

        if [[ -d "$PluginDir/.git" ]]; then
            zsh-plugin-update "$PluginName" || UpdateFailed=1
        fi
    done

    if (( ! UpdateFailed )); then
        touch "$ZSH_PLUGINS_UPDATE_FILE"
    else
        print -u2 -P "%F{yellow}⚠ zsh:%f marker обновлений не обновлён из-за ошибки"
    fi
fi



# Режим редактирования командной строки в стиле Emacs
bindkey -e

# История
HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000

setopt append_history
setopt share_history
setopt hist_ignore_dups
setopt hist_find_no_dups
setopt hist_reduce_blanks
setopt inc_append_history

# Completion zsh
autoload -Uz compinit
zmodload zsh/complist
compinit

# Интерфейс completion
zstyle ':completion:*' menu select=1
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
zstyle ':completion:*:warnings' format '%F{red}Нет совпадений%f'

# Fish-подобные серые подсказки
if [[ -r "$ZSH_PLUGINS_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
    source "$ZSH_PLUGINS_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh"
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
else
    print -u2 -P "%F{yellow}⚠ zsh:%f плагин zsh-autosuggestions недоступен"
fi

# Ctrl+F принимает подсказку целиком, → — следующий символ
bindkey '^F' autosuggest-accept
bindkey "${terminfo[kcuf1]}" forward-char

# История по введённому префиксу: ↑ / ↓
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey "${terminfo[kcuu1]}" up-line-or-beginning-search
bindkey "${terminfo[kcud1]}" down-line-or-beginning-search

# Fallback для терминалов, которые не передают terminfo-коды
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search
bindkey '\eOA' up-line-or-beginning-search
bindkey '\eOB' down-line-or-beginning-search

# Prompt
autoload -Uz colors vcs_info
colors

setopt prompt_subst
zstyle ':vcs_info:git:*' formats ' %F{magenta}git:%b%f'
zstyle ':vcs_info:*' enable git

precmd () {
    vcs_info
}

if (( EUID == 0 )); then
    PROMPT_IDENTITY='%F{red}%n@%m%f'
    PROMPT_SYMBOL='%F{red}❯%f'
else
    PROMPT_IDENTITY='%F{green}%n@%m%f'
    PROMPT_SYMBOL='%F{cyan}❯%f'
fi

PROMPT='
${PROMPT_IDENTITY} %F{blue}%~%f${vcs_info_msg_0_}
%(?..%F{red}↳ %?%f )${PROMPT_SYMBOL} '

RPROMPT='%F{242}%D{%H:%M}%f'

# Подсветка синтаксиса: всегда последней
if [[ -r "$ZSH_PLUGINS_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
    source "$ZSH_PLUGINS_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
else
    print -u2 -P "%F{yellow}⚠ zsh:%f плагин zsh-syntax-highlighting недоступен"
fi


export PATH="$HOME/.local/bin:$PATH"

# GitHub Copilot CLI
COPILOT_PROXY_ENV_FILE="$HOME/.vscode-server-insiders/server-env-setup"
copilot () {
    if [[ ! -r "$COPILOT_PROXY_ENV_FILE" ]]; then
        print -u2 -P \
            "%F{red}Copilot не запущен:%f нет или недоступен файл %F{yellow}$COPILOT_PROXY_ENV_FILE%f"

        return 1
    fi

    (
        source "$COPILOT_PROXY_ENV_FILE" || exit 1

        command copilot "$@"
    )
}

# Обновление конфигурации zsh из GitHub
zsh-update () {
    local ConfigUrl='https://raw.githubusercontent.com/Suntechnic/howto/refs/heads/main/hosts/files/.zshrc'
    local TempFile
    local BackupFile="$HOME/.zshrc.bak"

    TempFile="$(mktemp "${TMPDIR:-/tmp}/zshrc.XXXXXX")" || return 1

    if ! curl --fail --silent --show-error --location \
        "$ConfigUrl" \
        --output "$TempFile"; then
        print -u2 -P "%F{red}✗ zsh:%f не удалось скачать конфигурацию"
        rm -f "$TempFile"

        return 1
    fi

    if ! zsh -n "$TempFile"; then
        print -u2 -P "%F{red}✗ zsh:%f синтаксическая ошибка в скачанном .zshrc"
        rm -f "$TempFile"

        return 1
    fi

    cp "$HOME/.zshrc" "$BackupFile" || {
        print -u2 -P "%F{red}✗ zsh:%f не удалось создать резервную копию"
        rm -f "$TempFile"

        return 1
    }

    mv "$TempFile" "$HOME/.zshrc"

    print -P "%F{green}✓ zsh:%f конфигурация обновлена"
    print -P "%F{242}Резервная копия:%f $BackupFile"

    source "$HOME/.zshrc"
}