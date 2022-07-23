#!/usr/bin/bash

# The following if statements check for required paths then sets variables accordingly.

if
    [[ ! -d "$HOME/srv/git" ]]; then
        mkdir $HOME/srv/git
elif
        git_dir="$HOME/srv/git"; then
        echo "\$git_dir set in home."
fi

if
    [ -f "$HOME/.var/log/git_sync.log" ]; then
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
                echo "Sync script set."
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
    if
        git branch --show-current | grep master; then
            git pull origin master && git push origin master && git push lab master
    else
            git pull origin test && git push origin test && git push lab test

    fi
}

# Manipulate dotfiles in a git-bare directory.
# Normally I will have created a Shell alias, for this command
# However it must be defined here.
# A video detailing how this method works can be found here:
# https://youtu.be/tBoLDpTWVOM
sync_dotfiles () {
    if
        [ -f /usr/bin/git ]; then
            dotfiles="/usr/bin/git --git-dir=$git_dir/dotfiles.git/ --work-tree=$HOME"
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
#git --git-dir=$git_dir/git_sync.git/ --work-tree=$sync_script -C status;
sync_dotfiles > $log;
    pushd $bin; sync >> $log;
        pushd $sync_script; sync >> $log;
            pushd $cronjobs; sync >> $log;
                pushd $org; sync >> $log;
                    pushd $www; sync >> $log
                        cd $HOME
                            unset bin sync_script cronjobs org www log;
                                echo "Cleared variables"
                                    cowsay "Sync Complete"
