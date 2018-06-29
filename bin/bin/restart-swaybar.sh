#!/bin/bash

export SWAYSOCK=$(ls /run/user/*/sway-ipc.*.sock | head -n 1)
killall swaybar
swaybar --bar_id bar-0
