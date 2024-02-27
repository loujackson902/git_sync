remotes="origin"

dotfiles="$HOME/git/dotfiles.git"
config="/usr/bin/git --git-dir=$dotfiles --work-tree=$HOME"
if
    [ ! -d "$dotfiles" ];
    then
        git init --bare $dotfiles
fi

for r in $remotes
         do
             $config pull $r master&&
             $config push $r master
done

uofc="$HOME/git/uofc" # Website directory.
decades="$HOME/git/decades" # Website directory.
org="$HOME/git/org" # For notes, and miscellanious org documents.
scripts="$HOME/.local/bin/" # For general scripts.
gsync="$HOME/git/git_sync" # For my git-sync script
dirs="$uofc $decades $org $scripts $gsync"

for d in $( echo $dirs );
do
    git -C $d pull $remotes master&&
    git -C $d push $remotes master
done
