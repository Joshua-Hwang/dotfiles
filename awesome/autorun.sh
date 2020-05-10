#!/usr/bin/env bash

## run (only once) processes which spawn with the same name
function run {
   if (command -v $1 && ! pgrep $1); then
     $@&
   fi
}

## run (only once) processes which spawn with different name
if (command -v gnome-keyring-daemon && ! pgrep gnome-keyring-d); then
    gnome-keyring-daemon --daemonize --login &
fi
if (command -v start-pulseaudio-x11 && ! pgrep pulseaudio); then
    start-pulseaudio-x11 &
fi
if (command -v /usr/lib/mate-polkit/polkit-mate-authentication-agent-1 && ! pgrep polkit-mate-aut) ; then
    /usr/lib/mate-polkit/polkit-mate-authentication-agent-1 &
fi

## The following are not included in minimal edition by default
## but autorun.sh will pick them up if you install them

if (command -v system-config-printer-applet && ! pgrep applet.py ); then
  system-config-printer-applet &
fi

run compton --shadow-exclude '!focused'
run blueman-applet
run msm_notifier

# we re-source our resources file
run xrdb ~/.Xresources
xset r rate 250 60
xinput set-prop 14 355 -0.5
/usr/bin/libinput-gestures-setup start
run ibus-daemon -drx
run redshift-gtk
run feh --bg-fill $HOME/Pictures/wallpaper.jpg
run /home/joshua/bin/update-screen.sh
run nm-applet
run indicator-keylock
rum uim-toolbar-gtk3-systray
#run light-locker
#run xcape -e 'Super_L=Super_L|Control_L|Escape'
run thunar --daemon
run pamac-tray
run /home/joshua/bin/load-gui
