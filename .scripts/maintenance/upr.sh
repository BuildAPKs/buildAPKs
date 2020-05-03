#!/usr/bin/env sh
# Copyright 2020 (c)  all rights reserved by S D Rausty;  see LICENSE  
# https://sdrausty.github.io hosted courtesy https://pages.github.com
# File ` upr.sh ` can be used to update forks of this git repository.
#####################################################################
set -eu
git remote add upstream $(grep url .git/config |awk '{print $3}') ||:
git pull upstream $(grep url .git/config |awk '{print $3}') ||:
git checkout master
git fetch --all
git pull --rebase upstream master
git push origin master
# upr.sh EOF
