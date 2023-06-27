remotes='origin lab vps'
# local

dotfiles="$HOME/git/dotfiles.git"
config="/usr/bin/git --git-dir=$dotfiles --work-tree=$HOME"
if
    [ ! -d "$dotfiles" ];
    then
        git init --bare $dotfiles
        else
            echo "Dotfiles repo present."
fi

dotf_sync () {
             $config pull origin master
for r in $remotes
         do
             $config push $r master
done
}

www="$HOME/git/uofc" # Website directory.
org="$HOME/documents/org" # For notes, and miscellanious org documents.
scripts="$HOME/.local/bin/" # For general scripts.
gsync="$HOME/.local/bin/git-sync" # For my git-sync script
dirs="$www $org $scripts $gsync"

sync () {
for d in $( echo $dirs );
do
    git -C $d pull origin master;
}
