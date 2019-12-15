#!/bin/env sh

killall conky

conky -c $HOME/.config/conky/conkyrc-dark-bspwm &
sleep 0.8
conky -c $HOME/.config/conky/conkyrc-dark-bg &
