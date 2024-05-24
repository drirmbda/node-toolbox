#!/bin/bash


DISCORD_ID="readable_discord_user_name"
MINPORT=33300
MAXPORT=33309
for i in $(ls ~/.local/share/safe/node/)
do
  iPORT=$(cat ~/.local/share/safe/node/$i/PORT)
  if [[ $iPORT -le $MAXPORT && $iPORT -ge $MINPORT ]]; then
    echo ; echo "Replacing node with peer-id $i at port $iPORT..."
    iPID=$(lsof ~/.local/share/safe/node/$i/logs/safenode.log | grep "safenode " | grep -o "[0-9]*" | head -1)
    kill $iPID
    sleep 1
    echo "Starting replacement node with peer-id $i at port $iPORT..."
    screen -LdmS "safenode$iPORT" safenode --owner $DISCORD_ID  --port $iPORT --root-dir ~/.local/share/safe/node/$i --log-output-dest ~/.local/share/safe/node/$i/logs --max_log_files=9 --max_archived_log_files=0
    iPID=$(lsof ~/.local/share/safe/node/$i/logs/safenode.log | grep "safenode " | grep -o "[0-9]*" | head -1)
    echo "$iPID" > ~/.local/share/safe/node/$i/PID
    sleep 1
  fi
done