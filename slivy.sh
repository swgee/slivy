#!/bin/bash

function end_tail {
    while true; do
        # Every 0.1 seconds, check if the last line of the log file contains "sliver >"
        # indicating that the command has finished executing. If so, kill the tail process.
        sleep 0.1
        if [[ "$(tail -n 1 ~/.slivy-output | sed 's/\x1b\[[0-9;]*m//g')" == *"sliver >"* ]]; then
            pkill -f "tail.*slivy-output"
            break
        fi
    done
}

function execute_command() {
    echo "" > ~/.slivy-output # Clear the output file
    # Send command to tmux session, then start tailing the output.
    tmux send-keys -t slivy "$1" Enter
    end_tail &
    tail -f -n +1 ~/.slivy-output
}

function print_help {
    echo "SLIVY - Sliver Tmux Wrapper"
    echo
    echo "USAGE:"
    echo "  slivy                  Show this help menu"
    echo "  slivy <command>        Execute sliver command in persistent tmux session"
    echo "  slivy start            Initialize slivy"
    echo "  slivy end              Kill the background tmux session"
    echo ""
    echo "EXAMPLES:"
    echo "  slivy help             Show sliver console help"
    echo "  slivy generate ...     Generate implants"
    echo "  slivy jobs             List active jobs"
    exit 0
}

function start_slivy {
    echo "
 _______  _       _________                  
(  ____ \( \      \__   __/|\     /||\     /|
| (    \/| (         ) (   | )   ( |( \   / )
| (_____ | |         | |   | |   | | \ (_) / 
(_____  )| |         | |   ( (   ) )  \   /  
      ) || |         | |    \ \_/ /    ) (   
/\____) || (____/\___) (___  \   /     | |   
\_______)(_______/\_______/   \_/      \_/   
    "
    echo "Initializing slivy..."
    # Check if dependencies are installed
    if ! command -v tmux &> /dev/null; then
        echo "tmux not installed - please install using your distro's package manager"
        exit 1
    fi
    if ! command -v sliver &> /dev/null; then
        echo "sliver not installed - please install from https://github.com/BishopFox/sliver"
        exit 1
    fi
    tmux new-session -d -s slivy
    tmux send-keys -t slivy "sliver" Enter
    tmux pipe-pane -t slivy -o 'cat >> ~/.slivy-output'
    echo 'Created new tmux session "slivy" with sliver console, ready to use!'
    echo 'For slivy help, just run "slivy" ("slivy help" will show the sliver console help menu)'
    echo 'To kill the tmux session, run "slivy end", or "tmux kill-session -t slivy"'
    exit 0
}

if [ "$1" == "slivy-help" ]; then
    print_help
fi

if [ "$1" == "end" ]; then
    rm ~/.slivy-output
    if ! tmux has-session -t slivy 2>/dev/null; then
        echo "No tmux session 'slivy' found"
        exit 1
    fi
    tmux kill-session -t slivy
    echo "Killed tmux session 'slivy'"
    exit 0
fi

if [ "$1" == "start" ]; then
    if tmux has-session -t slivy 2>/dev/null; then
        echo "Tmux session 'slivy' already exists"
        exit 1
    fi
    start_slivy
    exit 0
fi

if ! tmux has-session -t slivy 2>/dev/null; then
    echo "Run 'slivy start' to initialize slivy"
    exit 1
fi

if [ "$#" -eq 0 ]; then
    print_help
fi

execute_command "$*" 2>/dev/null
printf "\033[1A\033[K"; echo # Clear the previous line with the extra sliver prompt