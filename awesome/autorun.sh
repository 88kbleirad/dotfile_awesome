
#!/bin/zsh
nitrogen --restore &
~/.screenlayout/setup_screen_29_03.sh &
picom --config ~/.config/picom/picom.conf &
docker start open-webui
pgrep -x fcitx5 >/dev/null || fcitx5 &
