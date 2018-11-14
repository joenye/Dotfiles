#!/bin/bash

for d in `ls -1d */`; do
  ( stow $d )
done
