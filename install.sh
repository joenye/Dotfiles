#!/bin/bash

for d in `ls -1d */ | grep -v '^\_.*'`; do
  ( stow $d )
done
