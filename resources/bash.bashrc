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

# Change to home directory when terminal is opened from virtual desktop
if [ "$PWD" == "/opt/noVNC" ]; then cd; fi
