#!/bin/bash

# Set $remotes variable
remotes="origin"

# Set dotfiles variable
dotfiles="$HOME/git/dotfiles.git"

# Set config command variable
config="/usr/bin/git --git-dir=$dotfiles --work-tree=$HOME"

# If statement to check for dotfiles directory. If directory is not present, one will be created
if
    [ ! -d "$dotfiles" ];
    then
        git init --bare $dotfiles
fi

# For loop to sync dotfiles
for r in $remotes
         do
             $config pull $r master&&
             $config push $r master
done

# Set remaining directory variables.
# Will possibly set up a loop for this in the future.
uofc="$HOME/git/uofc" # Website directory.
decades="$HOME/git/decades" # Website directory.
org="$HOME/git/org" # For notes, and miscellanious org documents.
scripts="$HOME/git/scripts/" # For general scripts.
gsync="$HOME/git/git_sync" # For my git-sync script
dirs="$uofc $decades $org $scripts $gsync"

# For loop to sync remaining directories with remote hosts
for d in $( echo $dirs );
do
    git -C $d pull $remotes master&&
    git -C $d push $remotes master
done
