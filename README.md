# RenPy-Wayland-Patcher
A simple GUI script for automatically adding the line "export SDL_VIDEODRIVER=x11" to the linux version of renpy games that they require to work under wayland

## Requirements
This program just needs "Zenity" to work properly. most distros come with this pre-installed, otherwise to install it:
#### Debian/ubuntu
`sudo apt install zenity`  
#### Fedora
`sudo dnf install zenity`  
#### Opensuse
`sudo zypper install zenity`  
#### Arch <sub>btw</sub>
`sudo pacman -S zenity`  
#### Gentoo
`sudo emerge --ask gnome-extra/zenity`
## Installation  

***DONT DOWNLOAD AS A ZIP***, use the release or directly use `git clone https://github.com/MelancholiaaEX/RenPy-Wayland-Patcher.git` in the Terminal. 

### if you do download it as a Zip
extract it  
do `chmod +x Wayland_Fixer.sh`

## Usage
Just place the .sh file in the folder you keep all your games in, and run it  
alternatively, you can also just run it from anywhere and select your game folder

### Note
This script assumes you have all your renpy games in folders, under one games folder. if you dont, just make one I guess `¯\_(ツ)_/¯`  
This script also assumes that your RenPy games include the .sh executable in the main game folder, and not in a subdirectory.  
for example  
`~/games/NAME/NAME.sh` with `games` being the folder with all other renpy games.  
**THIS WILL NOT WORK IF**  
your game is in another folder in your game folder. for example, `~/games/NAME/linux/NAME.sh`  
I did this to avoid adding the patch to other random .sh files, potentally breaking them. but I can change that if enough people want me to

