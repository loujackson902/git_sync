remotes='origin lab local vps'

dotfiles="$HOME/git/dotfiles.git"
if
    [ ! -d "$dotfiles" ];
    then
        git init --bare $dotfiles
        else
            echo "Dotfiles repo present."
fi

dotf () {
          "/usr/bin/git --git-dir=$dotfiles --work-tree=$HOME"
}

dotf_sync () {
             dotf pull origin master
for r in $remotes
         do
             dotf push r master
done
}
