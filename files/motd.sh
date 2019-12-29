#!/bin/bash

full=█
half=▌

normal="\e[0m"
black="\e[30m"
red="\e[31m"
green="\e[32m"
yellow="\e[33m"
blue="\e[34m"
magenta="\e[35m"
cyan="\e[36m"
lightGrey="\e[37m"

function printHeading {
  echo -e "${cyan}"
  echo "________  _________  ____ ___  ________  ______         "
  echo "\_____  \ \_   ___ \|    |   \/   __   \/  __  \________"
  echo " /  / \  \/    \  \/|    |   /\____    />      <\___   /"
  echo "/   \_/.  \     \___|    |  /    /    //   --   \/    / "
  echo "\_____\ \_/\______  /______/    /____/ \______  /_____ \\"
  echo "       \__>       \/                          \/      \/"
  echo -e "${normal}"
}

# Draw table header
function printDiskSpaceHeader {
  echo -e "${red}Disk space${normal}"
  for i in {0..50}
  do
        if  (( $i % 5 == 0))
        then
                header=${header}x
        else
                header=${header}.
        fi
  done
  
  echo -e "${blue}\t\t${header}${normal}"
}

function printDiskSpace {
  val=
  numberOfBigs=
  leftOver=
  var=

  val=$(df -h ${1} --output=pcent | tail -n 1 | sed 's/%//g')
  let numberOfBigs=(val/2)+1 # +1 for zero
  let leftOver=val%2
  
  for i in $(seq 1 ${numberOfBigs})
  do
    var=${var}${full}
  done

  if [ $leftOver -eq 1 ]
  then
        var=${var}${half}
  fi
  echo -e "${blue}${1} ${green}${2}${val}% \t${yellow}$var${normal}"
  #echo $numberOfBigs $leftOver
}

function printNetworks {
  printNetwork "ens33"
  echo ""
  printNetwork "br0"
}

function printNetwork {
  echo -e "${green}Nework Configuration: ${normal}${1}"
  echo -e "\t${blue}Address\t: ${normal}$(nmcli -g IP4.address dev show ${1})"
  echo -e "\t${blue}Gateway\t: ${normal}$(nmcli -g IP4.gateway dev show ${1})"
  echo -e "\t${blue}DNS\t: ${normal}$(nmcli -g IP4.DNS dev show ${1})"
}

function printCheckNTP {
  timedatectl | grep NTP\ enabled | grep yes > /dev/null
  rc=$?
  if [[ $rc != 0 ]]
  then
    echo -e "${green}NTP enabled: ${red}•${normal}"
  else
    echo -e "${green}NTP enabled: ${green}•${normal}"
  fi
  
  timedatectl | grep NTP\ synchronized | grep yes > /dev/null
  rc=$?
  if [[ $rc != 0 ]]
  then
    echo -e "${green}NTP in sync: ${red}•${normal}"
  else
    echo -e "${green}NTP in sync: ${green}•${normal}"
  fi
}

# ===================
# END Functions
# ===================

printHeading

echo -e "${green}HOSTNAME: ${normal}$(hostname) "
printCheckNTP
echo ""
printNetworks
echo ""
printDiskSpaceHeader
printDiskSpace "/" "\t"
printDiskSpace "/home" "\t"
echo ""
needs-restarting -r
echo ""