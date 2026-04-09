eval "$(oh-my-posh init zsh --config ~/.oh-my-posh/themes/catppuccin_mocha.omp.json)"

source ~/.zsh-plugin/zsh-autocomplete/zsh-autocomplete.plugin.zsh

alias ls='eza --icons --group-directories-first'
alias ll='eza -l --icons --group-directories-first'

export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS="@im=fcitx"
# Start dbus if not running
if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
    eval "$(dbus-launch --sh-syntax --exit-with-session)"
fi
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/nvim-linux-x86_64/bin"
alias fd='fdfind'
eval "$(zoxide init zsh)"
neofetch

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/dariel/miniforge3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/dariel/miniforge3/etc/profile.d/conda.sh" ]; then
        . "/home/dariel/miniforge3/etc/profile.d/conda.sh"
    else
        export PATH="/home/dariel/miniforge3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


# >>> mamba initialize >>>
# !! Contents within this block are managed by 'mamba shell init' !!
export MAMBA_EXE='/home/dariel/miniforge3/bin/mamba';
export MAMBA_ROOT_PREFIX='/home/dariel/miniforge3';
__mamba_setup="$("$MAMBA_EXE" shell hook --shell zsh --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__mamba_setup"
else
    alias mamba="$MAMBA_EXE"  # Fallback on help from mamba activate
fi
unset __mamba_setup
# <<< mamba initialize <<<
#

alias virt-manager='/usr/bin/python3 /usr/sbin/virt-manager'
alias virt-install='/usr/bin/python3 /usr/sbin/virt-install'
export LIBVIRT_DEFAULT_URI="qemu:///system"
alias python="python3.11"
alias python3="python3.11"
alias pip="pip3.11"





