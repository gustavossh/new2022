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
clear
#
clear
empresaatual=$(cut -d"'" -f2 /var/www/html/empresa)

echo ""
echo -e "\E[44;1;37m        MUDAR NOME DA LOGO        \E[0m"
echo ""
echo -e "                           \033[1;31mBy @jsinfinity\033[1;36m"
echo ""
echo ""
echo -e "\033[1;36m NOME ATUAL:\033[1;37m $empresaatual\033[0m"
echo ""
echo -ne "\033[1;32m INFORME O NOME DA LOGO\033[1;37m: "; read -r empresa
echo ""
echo -e "   \033[1;32mOK\033[1;37m"
echo ""
clear
#
cd || exit
sed -i "s;$empresaatual;$empresa;g" /var/www/html/empresa > /dev/null 2>&1
sed -i "s;$empresaatual;$empresa;g" /var/www/html/home.php > /dev/null 2>&1
sed -i "s;$empresaatual;$empresa;g" /var/www/html/index.php > /dev/null 2>&1
sed -i "s;$empresaatual;$empresa;g" /var/www/html/login.php > /dev/null 2>&1
sed -i "s;$empresaatual;$empresa;g" /var/www/html/admin/home.php > /dev/null 2>&1
sed -i "s;$empresaatual;$empresa;g" /var/www/html/admin/index.php > /dev/null 2>&1
sed -i "s;$empresaatual;$empresa;g" /var/www/html/admin/login.php > /dev/null 2>&1
echo ""
echo -e "\033[1;36m NOME ALTERADO PARA:\033[1;37m $empresa\033[0m"
sleep 5
cat /dev/null > ~/.bash_history && history -c
clear
pweb