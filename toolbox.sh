#!/bin/bash

# Define the variables and their default values
MINPORT=12000
MAXPORT=1202
NODE_DIR="$HOME/.local/share/safe/node/"

#Whiptail setup
export NEWT_COLORS='
window=,white
border=black,white
textbox=black,white
button=black,white
'
export TERM=xterm-256color

# Create a whiptail script to ask for user input
whiptail --title "Node Toolbox" \
         --inputbox "User or system mode? If you are in any doubt, accept the default user mode:" 10 60 3 $(printf '%s\n' "${options[@]}")



whiptail --title "Node Toolbox" \
         --inputbox "Enter the minimum port number (integer only): " 10 60 "$MINPORT" 3>&1 1>&2 2>&3 min_port
if [[ $min_port =~ ^[1-9][0-9]*$ && $min_port -ge 12000 && $min_port < 49151 ]]; then
    MINPORT=$min_port
else
    echo "Invalid input, please enter a positive integer between 12000 and 49151" >&2
fi

whiptail --title "Node Toolbox" \
         --inputbox "Enter the maximum port number (integer only): " 10 60 "$MAXPORT" 3>&1 1>&2 2>&3 max_port
if [[ $max_port =~ ^[1-9][0-9]*$ && $max_port -gt $MINPORT ]]; then
    MAXPORT=$max_port
else
    echo "Invalid input, please enter a positive integer greater than $MINPORT" >&2
fi

for i in $(ls $NODE_DIR)
do
  iPID=$(lsof $NODE_DIR$i/logs/safenode.log | grep "safenode " | grep -o "[0-9]*" | head -1)
  iPORT=$(netstat -lnup 2> /dev/null | grep "$iPID/safenode" | grep -o "[0-9]*" | head -7 | tail -n1)
  if [[ $iPORT -le $MAXPORT && $iPORT -ge $MINPORT ]]; then
    echo "stopping node peer-id $i at port $iPORT"
    echo "$iPORT" > $NODE_DIR$i/PORT
    kill $iPID
  else
    echo "skipping pid $iPID on port $iPORT (not in range or not running)"
  fi
done

exit 0     #bail here for now

PORTNUMBER=30910
for i in $(ls $NODE_DIR)
do
  iPORTLOG=$(cat $NODE_DIR$i/PORT) || iPORTRUN=$(netstat -lnup 2> /dev/null | grep "$iPID/safenode" | grep -o "[0-9]*" | head -7 | tail -n1)
  echo -n "."
  if [[ $iPORTRUN -eq $PORTNUMBER || $iPORTLOG -eq $PORTNUMBER ]]; then
    RESULT="$HOM$NODE_DIR$i/logs/safenode.log"
    echo ; echo "$RESULT"
    kill -INT $$  #break
  fi
done
#vdash $(realpath $RESULT)


CPUMAX=90.0 # Required cpu % or lower to exit monitoring loop
cpu=100
while [ 1 -eq "$(echo "$cpu > $CPUMAX" | bc )" ]
do
 cpu=$(awk '{u=$2+$4; t=$2+$4+$5; if (NR==1){u1=u; t1=t;} else print ($2+$4-u1) * 100 / (t-t1) ; }' <(grep 'cpu ' /proc/stat) <(sleep 1;grep 'cpu ' /proc/stat))
 echo -n "."
done
echo "reached $cpu %"


