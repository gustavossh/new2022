#!/bin/bash
clear
fun_bar () {
comando[0]="$1"
comando[1]="$2"
 (
[[ -e $HOME/fim ]] && rm $HOME/fim
${comando[0]} -y > /dev/null 2>&1
${comando[1]} -y > /dev/null 2>&1
touch $HOME/fim
 ) > /dev/null 2>&1 &
 tput civis
echo -ne "  \033[1;33mAGUARDE \033[1;37m- \033[1;33m["
while true; do
   for((i=0; i<18; i++)); do
   echo -ne "\033[1;31m#"
   sleep 0.1s
   done
   [[ -e $HOME/fim ]] && rm $HOME/fim && break
   echo -e "\033[1;33m]"
   sleep 1s
   tput cuu1
   tput dl1
   echo -ne "  \033[1;33mAGUARDE \033[1;37m- \033[1;33m["
done
echo -e "\033[1;33m]\033[1;37m -\033[1;32m OK !\033[1;37m"
tput cnorm
}
echo ""
echo -e "           \033[1;33m● \033[1;32mATUALIZANDO LINUX, Pode Demorar \033[1;33m●\033[0m"
fun_update () {
    yum update -y > /dev/null 2>&1 
	yum install figlet -y > /dev/null 2>&1
}
fun_bar 'fun_update'
echo ""
clear
#
IP=$(wget -qO- ipv4.icanhazip.com)
echo "America/Sao_Paulo" > /etc/timezone
ln -fs /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
dpkg-reconfigure --frontend noninteractive tzdata
clear
echo -e "\E[44;1;37m    ATUALIZANDO O PAINELWEB GESTOR-SSH     \E[0m"
echo ""
echo -e "                              \033[1;31mBy @nandoslayer\033[1;36m"
echo -e "   GESTOR-SSH" | figlet
echo ""
clear
#
senha=$(cut -d"'" -f2 /var/www/html/pages/system/pass.php)
echo ""
sleep 2
echo -e "           \033[1;33m● \033[1;32mFINALIZANDO A ATUALIZAÇÃO, PODE DEMORAR \033[1;33m● \033[1;33mAGUARDE...\033[0m"
cd /var/www/html || exit
rm -rf *
wget https://github.com/nandoslayer/plusnssh/raw/ntech/gestorssh/gestorssh.zip > /dev/null 2>&1
sleep 1
unzip -o gestorssh.zip > /dev/null 2>&1
rm -rf gestorssh.zip index.html > /dev/null 2>&1
mkdir /root/backupsql > /dev/null 2>&1
chmod 777 /root/backupsql > /dev/null 2>&1
chmod 777 -R /var/www/ > /dev/null 2>&1
sleep 1
if [[ -e "/var/www/html/pages/system/pass.php" ]]; then
sed -i "s;1020;$senha;g" /var/www/html/pages/system/pass.php
fi
#
clear
IP=$(wget -qO- ipv4.icanhazip.com)
clear
echo ""
echo -e "                              \033[1;31mBy @nandoslayer\033[1;36m"
echo -e "   GESTOR-SSH" | figlet
echo ""
echo -e "\033[1;36m PAINELWEB DIGITE ESSE IP NO NAVEGADOR:\033[1;37m http://$IP/admin\033[0m"
echo ""
sleep 5
service apache2 restart
cat /dev/null > ~/.bash_history && history -c
clear
pweb