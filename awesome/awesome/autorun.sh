
#!/bin/zsh
nitrogen --restore &
~/.screenlayout/setup_screen_vertical.sh &
picom --config ~/.config/picom/picom.conf &

pgrep -x fcitx5 >/dev/null || fcitx5 &
