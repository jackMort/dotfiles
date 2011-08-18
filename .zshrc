# My .zshrc file
# file:     $HOME/.zshrc 
# author: Ivo 
# modified: 04.05.2011
###########################################################         
# Options for Zsh
 
# History Config 

export HISTFILE=~/.zsh_history
export HISTSIZE=2600
export SAVEHIST=2600
eval `dircolors -b`  
 
############################################
# Set Option 

setopt autocd
setopt NO_BEEP
setopt HIST_REDUCE_BLANKS
setopt APPEND_HISTORY
setopt HIST_IGNORE_DUPS  
setopt hist_ignore_space 
setopt correct_all        
        
#####################################
# Vars used later on by Zsh  

export EDITOR="vim" 
export BROWSER="luakit"  
LANG='pl_PL.utf8' 

###############################################################################################
# Zstyle 
autoload -U compinit 
compinit 
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache 
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always 
zstyle ':completion:*' verbose yes
zstyle ':completion:*:match:*' original only 
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*' file-sort name
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' max-errors 2                        
zstyle ':completion:*' prompt 'correction: %e '  

#################################################################################################
# Terminal colours 

autoload colors zsh/terminfo
if [[ "$terminfo[colors]" -ge 8 ]]; then
	colors
fi

for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
	eval PR_$color='%{$terminfo[bold]$fg[${(L)color}]%}'
	eval PR_LIGHT_$color='%{$fg[${(L)color}]%}'

	export PR_$color
	export PR_LIGHT_$color
done  

######################################################################################################
# prompt
function prompt_git_dirty() {
    gitstat=$(git status 2>/dev/null | grep '\(# Untracked\|# Changes\|# Changed but not updated:\)')
    
    if [[ $(echo ${gitstat} | grep -c "^# Changes to be committed:$") > 0 ]]; then
        echo -n $PR_LIGHT_YELLOW
    elif [[ $(echo ${gitstat} | grep -c "^\(# Untracked files:\|# Changed but not updated:\)$") > 0 ]]; then
        echo -n $PR_LIGHT_RED
    else
        echo -n $PR_LIGHT_MAGENTA
    fi
}

function prompt_current_branch() {
    ref=$(git symbolic-ref HEAD 2> /dev/null) || return 1
    echo ${ref#refs/heads/}
}

function prompt_hostname()
{
    case "`hostname`" in
        "Arch")
            echo -n "${PR_LIGHT_GREEN}Arch${PR_NO_COLOR}";;    
    esac
}

function precmd() # Uses: setting user/root PROMPT1 variable and rehashing commands list
{
    # Last command status
    cmdstatus=$?
    sadface=`[ "$cmdstatus" != "0" ] && echo "${PR_RED}:(${PR_NO_COLOR} "`

    # Colours
    usercolour=`[ $UID != 0 ]   && echo $PR_WHITE      || echo $PR_RED`
    usercolour2=`[ $UID != 0 ]  && echo $WHITE || echo $PR_RED` 
    dircolour=`[ -w "\`pwd\`" ] && echo $PR_BLUE       || echo $PR_RED` 

    # Git branch
    git="[branch: `prompt_git_dirty``prompt_current_branch`${blue}]"

export PROMPT="
${usercolour}┌─[•${dircolour}%n${PR_NO_COLOR}«»`prompt_hostname`${usercolour}•]─────────────────────────${dircolour}[%~]${PR_NO_COLOR} `prompt_current_branch &>/dev/null && echo -n $git`
${usercolour}└─${sadface}${usercolour}${dircolour}(%T)(%l)${usercolour}keep it simple ─╼ ${PR_NO_COLOR}"                          
}                                        
#
#based on Barrucadu (prompt):https://bbs.archlinux.org/viewtopic.php?pid=831695#p831695
# 
###########################################################################################
# Urxvt Color Theme

FGNAMES=('█ █' '█ █' '█ █' '█ █' '█ █' '█ █' '█ █' '█ █')
BGNAMES=('  ')

for b in $(seq 0 0); do
    if [ "$b" -gt 0 ]; then
      bg=$(($b+39))
    fi
#echo -en "\033[0m ${BGNAMES[$b]}"
echo
    for f in $(seq 0 7); do
      echo -en "\033[${bg}m\033[$(($f+30))m ${FGNAMES[$f]} "
      echo -en "\033[${bg}m\033[1;$(($f+30))m ${FGNAMES[$f]} "
    done
echo
  echo -e "\033[0m"  

done

############################################################################# 

#Short command aliases
 
#Pacman  

alias 'pacupg=sudo pacman -Syu'        # Synchronize with repositories before upgrading packages that are out of date on the local system. 
alias 'pacin=sudo pacman -S'           # Install specific package(s) from the repositories
alias 'pacins=sudo pacman -U'          # Install specific package not from the repositories but from a file  
alias 'pacre=sudo pacman -R'           # Remove the specified package(s), retaining its configuration(s) and required dependencies 
alias 'pacrem=sudo pacman -Rns'        # Remove the specified package(s), its configuration(s) and unneeded dependencies 
alias 'pacrep=pacman -Si'              # Display information about a given package in the repositories 
alias 'pacreps=pacman -Ss'             # Search for package(s) in the repositories 
alias 'pacloc=pacman -Qi'              # Display information about a given package in the local database 
alias 'paclocs=pacman -Qs'             # Search for package(s) in the local database 
 
#Power 

alias 'reboot=sudo shutdown -r now'
alias 'poweroff=sudo shutdown -h now' 
alias 'x=startx' 
  
#misc alias   
alias 'mocp=mocp -T old_school_theme' 
alias 'nano=nano -Wx' 
alias 'scrot=scrot -c -d 5'  
alias 'scs=scrot -s' 
alias 'usb=sudo mount /dev/sdb1 /mnt/usb'
alias 'rec=recordmydesktop' 
alias 'ranger=sudo ranger'   
alias 'df=df -h'
alias 'du=du -h' 
alias 'ls= ls -lh --color=auto'
alias 'cam=guvcview'   

#CD Hacks 
alias '..=cd..' 
alias '..2=cd ../..' 
alias '..3=cd../../..'  
alias '..4=cd ../../../..'  
alias '..5=cd ../../../../..'
  
#List Processes
alias 'pse=ps -ef'   
alias 'psi=ps -f -u ivo'  
alias 'psforest=ps -e -o pid,args --forest'  
    
#github 
 
alias 'ga=git add' 
alias 'gc=git commit -m update' 
alias 'gp=git push' 
alias 'gpu=git pull'  
alias 'gst=git status'   
 
#net 
alias 'myip=curl ifconfig.me'    
alias 'wlan0=dmesg  | grep wlan0'  
alias 'pi=ping -c 4 google.com' 
alias 'iw=iwconfig' 
alias 'maptcp=sudo nmap cb.vu' 
alias 'ifd=sudo ifconfig wlan0 down'
 
#Pentest :)
 
alias 'msfconsole=/opt/metasploit/msfconsole'  
alias 'mac=ifconfig wlan0 hw ether 00:01:02:03:04:05' 
alias 'ipup=echo 1 > /proc/sys/net/ipv4/ip_forward' 
alias 'redirect=iptables -t nat -A PREROUTING -p tcp --destination-port 80 -j REDIRECT --to-port 10000' 
alias 'ettercap=sudo ettercap -i wlan0 -T -q -M arp // //'  
alias 'url=sudo urlsnarf -i wlan0' 
alias 'msg=msnsnarf -i wlan0' 
alias 'file=sudo filesnarf -i wlan0' 
alias 'rkhunter=sudo rkhunter -c' 

 
#Extract Files 
 
extract () {
	if [ -f $1 ]; then
		case $1 in
			*.tar.bz2)	tar xjf $1	;;
			*.tar.gz)	tar xzf $1	;;
			*.bz2)		bunzip2 $1	;;
			*.gz)		gzip -d $1	;;
			*.rar)		unrar e $1	;;
			*.tar)		tar xf $1	;;
			*.tbz2)		tar xjf $1	;;
			*.tgz)		tar xzf $1	;;
			*.zip)		unzip $1	;;
			*.7z)		7z x $1		;;
			*)		echo "'$1' cannot be extracted via extract()" ;;
		esac
	else
		echo "'1' is not a valid file"
	fi
}

##################################################### 
##################################################################
# Key bindings
#  http://mundy.yazzy.org/unix/zsh.php
#  http://www.zsh.org/mla/users/2000/msg00727.html

typeset -g -A key
bindkey '^?' backward-delete-char
bindkey '^A' beginning-of-line
bindkey '^[[5~' up-line-or-history
bindkey '^[[3~' delete-char
bindkey '^E' end-of-line
bindkey '^[[6~' down-line-or-history
bindkey '^[[A' up-line-or-search
bindkey '^[[D' backward-char
bindkey '^[[B' down-line-or-search
bindkey '^[[C' forward-char 
# completion in the middle of a line
bindkey '^i' expand-or-complete-prefix
  
