eval "$(~/.local/bin/oh-my-posh init zsh --config ~/.oh-my-posh/themes/catppuccin.omp.json)"

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

fastfetch
