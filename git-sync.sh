#!/bin/bash

# Set $remotes variable
remotes="origin"
echo '$origin set'

# Set dotfiles variable
dotfiles="$HOME/git/dotfiles.git"
echo '$dotfiles set'

# Set config command variable
config="/usr/bin/git --git-dir=$dotfiles --work-tree=$HOME"
echo '$config set'

# If statement to check for dotfiles directory. If directory is not present, one will be created
if
    [ ! -d "$dotfiles" ];
    then
        git init --bare $dotfiles
        echo '\$dotfiles not found, creating initializing git bare directory'
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
echo '$uofc set'
decades="$HOME/git/decades" # Website directory.
echo '$decades set'
org="$HOME/git/org" # For notes, and miscellanious org documents.
echo '$org set'
scripts="$HOME/git/scripts/" # For general scripts.
echo '$scripts set'
gsync="$HOME/git/git_sync" # For my git-sync script
echo '$gsync set'
dirs="$uofc $decades $org $scripts $gsync"
echo 'Directory variables created'

# For loop to sync remaining directories with remote hosts
for d in $( echo $dirs );
do
    git -C $d pull $remotes master&&
    git -C $d push $remotes master
done

# Clear previously set variables
unset remotes dotfiles config r uofc decades org scripts gsync dirs;
echo "Cleared variables"
