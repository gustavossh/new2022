#!/bin/bash
menu(){
ipweb=$(curl https://bigbolgames.com)
clear
tput setaf 7 ; tput setab 4 ; tput bold ; printf '%30s%s%-10s\n' "Instalador PainelWEB MultiHD-SSH CENTOS 7" ; tput sgr0 ; echo ""
echo "Continuar? Y\n"
echo -n "> "
read option
if [ $option = "Y" ]; then
install
elif [ $option = "y" ]; then
install
elif [ $option = "n" ]; then
exit
elif [ $option = "N" ]; then
exit
else
menu
fi
}
install(){
clear
yum update -y
yum upgrade -y
yum install epel-release -y 
yum install php htop zip nload nano phpmyadmin httpd mysql mariadb-server php-pecl-ssh2 -y --skip-broken
yum install gcc php-devel libssh2 libssh2-devel php-pear make php-mcrypt unzip wget screen -y --skip-broken
setsebool -P httpd_can_network_connect 1
systemctl enable httpd 
systemctl enable mariadb
service httpd restart
service mariadb start
dbconfig
}
dbconfig(){
clear
echo "Insira a senha do ROOT Banco de dados"
echo -n "> "
read root_password
if [ -z $root_password ]; then
clear 
echo "Por favor coloque senha do MYsql"
sleep 2
dbconfig
else
mysql -e "UPDATE mysql.user SET Password = PASSWORD('$root_password') WHERE User = 'root'"
mysql -e "FLUSH PRIVILEGES"
phpmyadminfix
fi
}
phpmyadminfix(){
rm /etc/httpd/conf.d/phpMyAdmin.conf
wget https://github.com/gustavossh/new2022/raw/main/Painel-V2022/phpMyAdmin.conf -O /etc/httpd/conf.d/phpMyAdmin.conf
chmod 777 /etc/httpd/conf.d/phpMyAdmin.conf
service httpd restart
installweb
}
installweb(){
cd /var/www/html
wget https://github.com/gustavossh/new2022/raw/main/Painel-V2022/gestorssh.zip
unzip gestorssh.zip
sed -i "s;1020;$root_password;g" /var/www/html/pages/system/pass.php > /dev/null 2>&1
rm gestorssh.zip
chmod 777 -R /var/www/
cd
createdb
}
createdb(){
wget https://github.com/gustavossh/new2022/raw/main/Painel-V2022/bdgestorssh.sql
mysql -h localhost -u root -p$root_password -e "CREATE DATABASE sshplus"
mysql -h localhost -u root -p$root_password --default_character_set utf8 sshplus < bdgestorssh.sql
rm bdgestorssh.sql
croninstall
}
croninstall(){
crontab -l > cronset
echo "
* * * * * /bin/usersteste.sh
*/5 * * * * /bin/autobackup.sh
* * * * * /usr/bin/php /var/www/html/pages/system/cron.php
* * * * * /usr/bin/php /var/www/html/pages/system/cron.ssh.php
* * * * * /usr/bin/php /var/www/html/pages/system/cron.online.ssh.php
* * * * * /usr/bin/php /var/www/html/pages/system/cron.servidor.php
* * * * * /usr/bin/php /var/www/html/pages/system/cron.rev.php
*/1 * * * * /usr/bin/php /var/www/html/pages/system/cron.limpeza.php
0 */12 * * * cd /var/www/html/pages/system/ && bash cron.backup.sh && cd /root
5 */12 * * * cd /var/www/html/pages/system/ && /usr/bin/php cron.backup.php && cd /root" > cronset
crontab cronset && rm cronset
cd $HOME || exit
wget -qO- https://github.com/gustavossh/new2022/raw/main/Painel-V2022/uteste > /bin/usersteste.sh
wget -qO- https://github.com/gustavossh/new2022/raw/main/Painel-V2022/backupauto > /bin/autobackup.sh
chmod 777 /bin/usersteste.sh
chmod 777 /bin/autobackup.sh
mkdir /root/backupsql
final
}
final(){
clear
echo "Login Painel ADMIN: admin"
echo "Senha Painel ADMIN: admin"
echo "Acesso Painel ADMIN: $ipweb/admin"
echo "Acesso PHPMYADMIN: $ipweb/phpmyadmin"
echo "Login PHPMYADMIN: root" 
echo "senha PHPMYADMIN: $root_password"
echo "Backup dos dados do PHPMyadmin se encontra no /root/PHPMYADMIN.txt"
echo "Acesso PHPMYADMIN: $ipweb/phpmyadmin" >> PHPMYADMINDATA.txt
echo "Login PHPMYADMIN: root" >> PHPMYADMINDATA.txt
echo "senha PHPMYADMIN: $root_password" >> PHPMYADMINDATA.txt
sleep 10
}
