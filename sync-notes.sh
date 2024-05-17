#!/bin/bash

cd ~/Repos/Obsidian
git stash
git pull
git stash pop
git add .
git commit -m 'updates'
git push
