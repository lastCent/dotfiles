# Update Xresources
[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources
# Set background
feh --bg-scale /home/dodo_a/background/background.jpg &
# Start redshift
pgrep redshift &> /dev/null || redshift &> /dev/null &
compton &
sxhkd &
urxvt &
# Set keyboard layout to british
# setxkbmap gb &
# Set custom keybindings
[[ -f ~/.Xmodmap ]] && xmodmap ~/.Xmodmap
# Start lemonbar
./lemonbarScript/bar.sh | lemonbar -f "Source Code Pro Light" -B '#171717' -F '#ebdbb2' &

exec bspwm
