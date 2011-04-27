#!/bin/bash

# ------------------------------------------
# Control vms using VboxManage commands.
# portvm %VM%
# startvm %VM%
# pauseallvms
# ------------------------------------------

# pause or resume a vm.
porvm() {
if test $# -ne 1
then
   echo 'error: hikisu ha ikko ja na kya dame' 1>&2
   exit 1
fi
for i in $*
do
   vmstate=`VBoxManage showvminfo "${i}" | grep State`
   vmstate=`echo ${vmstate} | sed -e 's/State: \(.*\) (.*)/\1/'`
   if [ ${vmstate} = running ]; then
      VBoxManage controlvm "${*}" pause
      echo "${*}: Paused."
   elif [ ${vmstate} = paused ]; then
      VBoxManage controlvm "${*}" resume
      echo "${*}: Resumed."
   else
      echo "${*} is now ${vmstate}"
   fi
done
}

startvm() {
# start a vm.
if test $# -ne 1
then
   echo 'error: hikisu ha ikko ja na kya dame' 1>&2
   exit 1
fi
for i in $*
do
   #i="\"${i}\""
   VBoxManage startvm ${i}
done
}

pauseallvms() {
@pauseallvms() {
   # get status of runningvm
   vmstate=`VBoxManage showvminfo "${*}" | grep State`
   vmstate=`echo ${vmstate} | sed -e 's/State: \(.*\) (.*)/\1/'`

   # pause runningvm
   if [ ${vmstate} = running ]; then
      VBoxManage controlvm "${*}" pause
      echo "${*}: Paused."
   elif [ ${vmstate} = paused ]; then
      echo "${*}: Already paused."
   else
      echo "${*} is now ${vmstate}"
   fi
}

# are there runningvms?
## get runningvms list (including uuid)
runningvm=`VBoxManage list runningvms`
declare -a vms=(`echo ${runningvm} | sed -e 's/[ ]/\n/g'`)
## get runningvm list excluding uuid
declare -a avms
declare -i i=${#vms[@]}
declare -i j=0
declare -i k=0
while [ $i -gt 0 ]; do
   declare -i l=$i%2
      if [ $j = 0 ];then
         avms[$j]=`echo ${vms[$k]} | sed -e 's/"\([^"]*\)"/\1/g'`
         let ++j
      elif [ $l = 0 ];then
         avms[$j]=`echo ${vms[$k]} | sed -e 's/"\([^"]*\)"/\1/g'`
         let ++j
      fi
   let --i
   let ++k
done

# pause all vms
for (( i = 0; i < ${#avms[@]}; ++i )); do
      @pauseallvms ${avms[$i]}
done
}
