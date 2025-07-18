# Slivy

```
 _______  _       _________                  
(  ____ \( \      \__   __/|\     /||\     /|
| (    \/| (         ) (   | )   ( |( \   / )
| (_____ | |         | |   | |   | | \ (_) / 
(_____  )| |         | |   ( (   ) )  \   /  
      ) || |         | |    \ \_/ /    ) (   
/\____) || (____/\___) (___  \   /     | |   
\_______)(_______/\_______/   \_/      \_/   
```

A Tmux wrapper for the Sliver C2 console that lets you execute Sliver commands directly from the Linux shell.

## Dependencies

- `sliver`: Sliver C2 - Install from https://github.com/BishopFox/Sliver
- `tmux`: Terminal multiplexer - installed by default on most Linux distros

## Installation

```
curl https://raw.githubusercontent.com/swgee/slivy/refs/heads/main/slivy.sh -o slivy
[Add installation folder to PATH]
chmod +x slivy
slivy start
```

## Usage

- `slivy` - Show slivy help menu
- `slivy start` - Initialize slivy (creates sliver tmux session)
- `slivy <command>` - Execute any sliver command
- `slivy end` - Kill the background tmux session