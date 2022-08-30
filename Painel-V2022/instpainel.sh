#!/bin/bash
clear
echo "America/Sao_Paulo" > /etc/timezone
ln -fs /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime > /dev/null 2>&1
dpkg-reconfigure --frontend noninteractive tzdata > /dev/null 2>&1
clear
msg() {
   BRAN='\033[1;37m' && RED='\e[31m' && GREEN='\e[32m' && YELLOW='\e[33m'
  BLUE='\e[34m' && MAGENTA='\e[35m' && MAG='\033[1;36m' && BLACK='\e[1m' && SEMCOR='\e[0m'
  case $1 in
  -ne) cor="${RED}${BLACK}" && echo -ne "${cor}${2}${SEMCOR}" ;;
  -ama) cor="${YELLOW}${BLACK}" && echo -e "${cor}${2}${SEMCOR}" ;;
  -verm) cor="${YELLOW}${BLACK}[!] ${RED}" && echo -e "${cor}${2}${SEMCOR}" ;;
  -azu) cor="${MAG}${BLACK}" && echo -e "${cor}${2}${SEMCOR}" ;;
  -verd) cor="${GREEN}${BLACK}" && echo -e "${cor}${2}${SEMCOR}" ;;
  -bra) cor="${RED}" && echo -ne "${cor}${2}${SEMCOR}" ;;
  -nazu) cor="${COLOR[6]}${BLACK}" && echo -ne "${cor}${2}${SEMCOR}" ;;
  -gri) cor="\e[5m\033[1;100m" && echo -ne "${cor}${2}${SEMCOR}" ;;
  "-bar2" | "-bar") cor="${RED}————————————————————————————————————————————————————" && echo -e "${SEMCOR}${cor}${SEMCOR}" ;;
  esac
}
fun_bar() {
  comando="$1"
  _=$(
    $comando >/dev/null 2>&1
  ) &
  >/dev/null
  pid=$!
  while [[ -d /proc/$pid ]]; do
    echo -ne " \033[1;33m["
    for ((i = 0; i < 20; i++)); do
      echo -ne "\033[1;31m##"
      sleep 0.5
    done
    echo -ne "\033[1;33m]"
    sleep 1s
    echo
    tput cuu1
    tput dl1
  done
  echo -e " \033[1;33m[\033[1;31m########################################\033[1;33m] - \033[1;32m100%\033[0m"
  sleep 1s
}

print_center() {
  if [[ -z $2 ]]; then
    text="$1"
  else
    col="$1"
    text="$2"
  fi

  while read line; do
    unset space
    x=$(((54 - ${#line}) / 2))
    for ((i = 0; i < $x; i++)); do
      space+=' '
    done
    space+="$line"
    if [[ -z $2 ]]; then
      msg -azu "$space"
    else
      msg "$col" "$space"
    fi
  done <<<$(echo -e "$text")
}

title() {
  clear
  msg -bar
  if [[ -z $2 ]]; then
    print_center -azu "$1"
  else
    print_center "$1" "$2"
  fi
  msg -bar
}

stop_install() {
  title "INSTALAÇÃO CANCELADA"
  exit
}

os_system() {
  system=$(cat -n /etc/issue | grep 1 | cut -d ' ' -f6,7,8 | sed 's/1//' | sed 's/      //')
  distro=$(echo "$system" | awk '{print $1}')

  case $distro in
  Debian) vercion=$(echo $system | awk '{print $3}' | cut -d '.' -f1) ;;
  Ubuntu) vercion=$(echo $system | awk '{print $2}' | cut -d '.' -f1,2) ;;
  esac
}

repo() {
  link="https://github.com/wellzin-blip/new2022/raw/master/Painel-V2022/source-list/$1.list"
  case $1 in
  8 | 9 | 10 | 11 | 14.04 | 16.04 | 18.04 | 20.04 | 20.10 | 21.04 | 21.10 | 22.04) wget -O /etc/apt/sources.list ${link} &>/dev/null ;;
  esac
}
dependencias() {
  soft="python"
   for i in $soft; do
    leng="${#i}"
    puntos=$((21 - $leng))
    pts="."
    for ((a = 0; a < $puntos; a++)); do
      pts+="."
    done
    msg -nazu "    Instalando $i$(msg -ama "$pts")"
    if apt install $i -y &>/dev/null; then
      msg -verd " INSTALADO"
    else
      msg -verm2 " ERRO"
      sleep 2
      tput cuu1 && tput dl1
      print_center -ama "aplicando fix a $i"
      dpkg --configure -a &>/dev/null
      sleep 2
      tput cuu1 && tput dl1

      msg -nazu "    Instalando $i$(msg -ama "$pts")"
      if apt install $i -y &>/dev/null; then
        msg -verd " INSTALADO"
      else
        msg -verm2 " ERRO"
      fi
    fi
  done
}
install_start() {
  msg -bar

  echo -e "\e[1;97m           \e[5m\033[1;100m   ATUALIZAÇÃO DO SISTEMA   \033[1;37m"
  msg -bar
  print_center -ama "Os pacotes do sistema estão sendo atualizados.\n Pode demorar um pouco e pedir algumas confirmações.\n"
  msg -bar3
  msg -ne "\n Você deseja continuar? [S/n]: "
  read opcion
  [[ "$opcion" != @(s|S) ]] && stop_install
  clear && clear
  msg -bar
  echo -e "\e[1;97m           \e[5m\033[1;100m   ATUALIZAÇÃO DO SISTEMA   \033[1;37m"
  msg -bar
  os_system
  apt update -y
  apt upgrade -y
  clear
}

install_continue() {
  os_system
  msg -bar
  echo -e "      \e[5m\033[1;100m   CONCLUINDO PACOTES PARA O SCRIPT   \033[1;37m"
  msg -bar
  print_center -ama "$distro $vercion"
  print_center -verd "INSTALANDO DEPENDÊNCIAS"
  msg -bar3
  dependencias
  msg -bar3
  print_center -azu "Removendo pacotes obsoletos"
  apt autoremove -y &>/dev/null
  sleep 2
  tput cuu1 && tput dl1
  msg -bar
  print_center -ama "Se algumas das dependências falharem!!!\nQuando terminar, você pode tentar instalar\no mesmo manualmente usando o seguinte comando\napt install nome_do_pacote"
  msg -bar
  read -t 60 -n 1 -rsp $'\033[1;39m       << Pressione enter para continuar >>\n'
}
install_continue2() {
[[ ! -d /etc/SSHPlus ]] && mkdir /etc/SSHPlus
[[ ! -d /etc/SSHPlus/Painel ]] && mkdir /etc/SSHPlus/Painel
rm /bin/pweb > /dev/null 2>&1
cd /bin || exit
wget https://github.com/wellzin-blip/new2022/raw/master/Painel-V2022/pweb > /dev/null 2>&1
chmod 777 pweb > /dev/null 2>&1
clear
[[ ! -d /bin/ppweb ]] && mkdir /bin/ppweb
cd /bin/ppweb || exit
rm *.sh versao* > /dev/null 2>&1
wget https://github.com/wellzin-blip/new2022/raw/master/Painel-V2022/install.sh > /dev/null 2>&1
wget https://github.com/wellzin-blip/new2022/raw/master/Painel-V2022/ubuinst.sh > /dev/null 2>&1
wget https://github.com/wellzin-blip/new2022/raw/master/Painel-V2022/senharoot.sh > /dev/null 2>&1
wget https://github.com/wellzin-blip/new2022/raw/master/Painel-V2022/restbanco.sh > /dev/null 2>&1
wget https://github.com/wellzin-blip/new2022/raw/master/Painel-V2022/restbanco18.sh > /dev/null 2>&1
wget https://github.com/wellzin-blip/new2022/raw/master/Painel-V2022/empresa.sh > /dev/null 2>&1
wget https://github.com/wellzin-blip/new2022/raw/master/Painel-V2022/updatepainel.sh > /dev/null 2>&1
wget https://github.com/wellzin-blip/new2022/raw/master/Painel-V2022/updatepainel18.sh > /dev/null 2>&1
wget https://github.com/wellzin-blip/new2022/raw/master/Painel-V2022/updatepainelarm.sh > /dev/null 2>&1
wget https://github.com/wellzin-blip/new2022/raw/master/Painel-V2022/updatepainelarm18.sh > /dev/null 2>&1
wget https://github.com/wellzin-blip/new2022/raw/master/Painel-V2022/versao > /dev/null 2>&1
chmod 777 *.sh > /dev/null 2>&1
echo -e "        \033[1;33m • \033[1;32mINSTALAÇÃO CONCLUÍDA\033[1;33m • \033[0m"
echo ""
echo -e "\033[1;31m \033[1;33mCOMANDO PRINCIPAL: \033[1;32mpweb\033[0m"
echo -e "\033[1;33m MAIS INFORMAÇÕES \033[1;31m(\033[1;36mTELEGRAM\033[1;31m): \033[1;37m@nandoslayer\033[0m"
cat /dev/null > ~/.bash_history && history -c
}
install_start
install_continue
install_continue2
