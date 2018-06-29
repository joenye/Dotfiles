#!/usr/bin/env bash 
 
for d in `ls -1d */`; do 
  ( stow -D $d ) 
done
