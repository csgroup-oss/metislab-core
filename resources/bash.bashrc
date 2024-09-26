echo -e "\e[1;34m"
# Using ascii art font speed (see http://patorjk.com/software/taag/#p=display&f=Speed&t=VRE)
cat<<LOGO
___    ___________________
__ |  / /__  __ \__  ____/
__ | / /__  /_/ /_  __/
__ |/ / _  _, _/_  /___
_____/  /_/ |_| /_____/


LOGO
echo -e "\e[0;33m"

cat<<MSG
Welcome to the Virtual Research Environment!

MSG

# Turn off colors
echo -e "\e[m"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/opt/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/opt/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# Change to home directory when terminal is opened from virtual desktop
if [ "$PWD" == "/opt/noVNC-1.2.0" ]; then cd; fi
