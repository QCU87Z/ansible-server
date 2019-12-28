#!/bin/bash

full=█
half=▌
# 50 spaces each worth 2%

# Draw table header
function printHeader {
  
  for i in {0..50}
  do
        if  (( $i % 5 == 0))
        then
                header=${header}x
        else
                header=${header}.
        fi
  done
  
  echo -e "\t\t${header}"
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
  echo -e "${1} ${2}${val}% \t$var"
  #echo $numberOfBigs $leftOver
}

printHeader
printDiskSpace "/" "\t"
printDiskSpace "/home" "\t"