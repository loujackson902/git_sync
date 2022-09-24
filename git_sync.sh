#!/usr/bin/bash

# The following if statements check for required paths then sets variables accordingly.
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
        sync_script="$bin/git_sync" &&
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

# Pull from origin, push to origin, push to lab.
sync () {
    #for dirs in $(cat dirs.txt); do
    git -C $bin pull origin master;
    git -C $bin push origin master;
    git -C $bin push lab master;
    git -C $cronjobs pull origin master;
    git -C $cronjobs push origin master;
    git -C $cronjobs push lab master;
    git -C $sync_script pull origin test;
    git -C $sync_script  push origin test;
    git -C $sync_script  push lab test;
    git -C $org pull origin master;
    git -C $org  push origin master;
    git -C $org  push lab master;
    git -C $www pull origin master;
    git -C $www  push origin master;
    git -C $www  push lab master;
    #         done
}

# Manipulate dotfiles
sync_dotfiles () {
    if
        [ -f /usr/bin/git ]; then
            dotfiles="/usr/bin/git --git-dir=$HOME/srv/git/dotfiles.git/ --work-tree=$HOME"
    else
            echo "Application not found, please install git"
    fi

    $dotfiles push origin master; $dotfiles pull origin master; $dotfiles push lab master
}


# This script no longer depends on git_keys.
# Check for keys script, then source script.
# if
#     [ -f "$bin/git_keys" ]; then
#         source "$bin/git_keys"
# fi

# Change into appropriate directories then run the sync function and send output to the log.
# sync_dotfiles > $log;
#     cd $bin; sync >> $log;
#         cd $cronjobs; sync >> $log;
#             cd $org; sync >> $log;
#                 cd $www; sync >> $log

sync_dotfiles;
sync
