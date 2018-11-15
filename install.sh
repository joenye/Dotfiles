#!/bin/bash

# Match all directories not prefixed with an underscore
for d in `ls -1d */ | grep -v '^\_.*'`; do
  ( stow $d )
done
