#!/usr/bin/bash

# The if statements contained within the set_vars function check for required paths then sets variables accordingly.

set_vars () {

## Check for a master git directory in home then set the path as a variable.
if
    [ -d "$HOME/git" ] ; then
        git_dir="$HOME/git" &&
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

## Check for bin directory in home folder then set path as a variable.
if
    [ -d "$HOME/.local/bin" ]; then
        bin="$HOME/.local/bin" &&
                echo "Bin set."
fi

## Check for cron directory in bin folder then set path as a variable.
if
    [[ -n "$bin" ]]; then
        cronjobs="$bin/cron" &&
                echo "Cronjobs set."
fi

## Check for git_sync directory in bin folder then set path as a variable.
if
    [[ -n "$bin" ]]; then
        git_sync="$bin/git_sync" &&
                echo "Git_Sync set."
fi

## Check for org directory in documents folder then set path as a variable.
if
    [ -d "$HOME/documents/org" ]; then
        org="$HOME/documents/org" &&
                echo "Org set."
fi

## Check for website directory in git folder then set path as a variable.
if
    [[ -n "$git_dir" ]]; then
        www="$git_dir/uofc" &&
                echo "Website directory set."
fi

## This conditional will set a loop variable for any repositories that use a test branch.
# if
#     [[ -n $git_sync ]]; then
#         test="$git_sync"
# else
#         echo "$git_sync not found"
# fi

## This conditional will set a loop variable for any repositories that use a master branch.
if
    [[ -n $bin ]] && [[ -n $cronjobs ]] && [[ -n $git_sync ]] && [[ -n $org ]] && [[ -n $www ]]; then
        master="$bin $git_sync $cronjobs $org $www"
else
        echo "Variable not found"
fi
}

# Manipulate dotfiles

sync_dotfiles () {
    ## The conditional in this function will check for git on the system then assign a variable for bare git repo manipulation.
    ## If git is not present on the system then the script will write to the log and exit.
    if
        [ -f /usr/bin/git ]; then
            dotfiles="/usr/bin/git --git-dir=$git_dir/dotfiles.git --work-tree=$HOME"
    else
            echo "Application not found, please install git" >> $log && exit
    fi

     $dotfiles push origin master;
     $dotfiles pull origin master;
     $dotfiles push lab master;
     $dotfiles push local master
 #    $dotfiles push vps master # toggle comment for personal git server
}

# Sync repos
sync () {
    set_vars;
    sync_dotfiles

    # Sync test branch.
    ## Uncomment the following lines to sync test branches.
# for t in $( echo $test );
# do
#     git -C $t pull origin test;
#     git -C $t push origin test;
#     git -C $t push lab test;
#     git -C $t push vps test
# done

    # Sync master branch.
for m in $( echo $master );
do
    git -C $m pull origin master;
    git -C $m push origin master;
    git -C $m push lab master;
    git -C $m push local master
#   git -C $m push vps master # toggle comment for personal git server
done
}

sync
