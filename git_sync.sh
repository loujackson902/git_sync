#!/usr/bin/bash

# The following if statements check for required paths then sets variables accordingly.
set_vars () {
if
    [ -d "$HOME/srv/git" ] ; then
        git_dir="$HOME/srv/git" &&
                echo "Git dir set in home."
else
        git_dir="/srv/git" &&
                echo "Git dir set in root"
fi

if
    [ -f "$HOME/.var/log/git_sync.log" ] ; then
        log="$HOME/.var/log/git_sync.log" &&
                echo "Logs set."
fi

if
    [ -d "$HOME/.local/bin" ]; then
        bin="$HOME/.local/bin" &&
                echo "Bin set."
fi

if
    [[ -n "$bin" ]]; then
        cronjobs="$bin/cron" &&
                echo "Cronjobs set."
fi

if
    [[ -n "$bin" ]]; then
        git_sync="$bin/git_sync" &&
                echo "Git_Sync set."
fi

if
    [ -d "$HOME/documents/org" ]; then
        org="$HOME/documents/org" &&
                echo "Org set."
fi

if
    [[ -n "$git_dir" ]]; then
        www="$git_dir/uofc" &&
                echo "www set."
fi

if
    [[ -n $git_sync ]]; then
        test="$git_sync"
else
        echo "$git_sync not found"
fi

if
    [[ -n $bin ]] && [[ -n $cronjobs ]] && [[ -n $git_sync ]] && [[ -n $org ]] && [[ -n $www ]]; then
        master="$bin $cronjobs $org $www"
else
        echo "Variable not found"
fi
}

# Manipulate dotfiles
sync_dotfiles () {
    if
        [ -f /usr/bin/git ]; then
            dotfiles="/usr/bin/git --git-dir=$git_dir/dotfiles.git --work-tree=$HOME"
    else
            echo "Application not found, please install git"
    fi

    $dotfiles push origin master;
    $dotfiles pull origin master;
    $dotfiles push lab master;
    $dotfiles push vps master
}

# Sync repos
sync () {
    set_vars;
    sync_dotfiles
for t in $( echo $test );
do
    git -C $t pull origin test;
    git -C $t push origin test;
    git -C $t push lab test;
    git -C $t push vps test
done

for m in $( echo $master );
do
    git -C $m pull origin master;
    git -C $m push origin master;
    git -C $m push lab master;
    git -C $m push vps master
done
}

sync
