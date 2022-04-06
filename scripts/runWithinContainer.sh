#!/bin/bash

# 
#    A bash script used with Docker for compiling The Ev3dev C++ Wrapper Library
#
#    Copyright (c) 2021, 2022 - Eisverygoodletter
#
#    This file is part of The Ev3dev C++ Wrapper Library.
#    The Ev3dev C++ Wrapper Library is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by the Free Software Foundation, 
#    either version 3 of the License, or (at your option) any later version.
#    The Ev3dev C++ Wrapper Library is distributed in the hope that it will be useful, 
#    but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or 
#    FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
#    You should have received a copy of the GNU General Public License 
#    along with The Ev3dev C++ Wrapper Library. If not, see <https://www.gnu.org/licenses/>.
echo -e "\e[1;37m"
# a function for creating a bar showing file size and the limit
# $1 is file name
# $2 is the max kilobytes
# $3 is file path
# $4 is progress bar length
function sizeBar() {
    FILENAME=$1
    FILEPATH=$3
    FILESIZE=$(stat -c%s "$FILEPATH")
    FILE_KILOBYTES=$(($FILESIZE / 1000))
    MAX_KILOBYTES=$2
    GREENBEGIN="\e[0;32m"
    COLOREND="\e[1;37m"
    REDBEGIN="\e[0;31m"
    echo
    echo -e "$GREENBEGIN$FILENAME$COLOREND's size is $GREENBEGIN$FILE_KILOBYTES$COLOREND kilobytes out of the $REDBEGIN$MAX_KILOBYTES$COLOREND kilobytes allowed"
    if (($FILE_KILOBYTES > $MAX_KILOBYTES)); then
        echo "The file is $REDBEGIN $(($FILE_KILOBYTES - $MAX_KILOBYTES)) $COLOREND kilobytes too large"
        echo
        return
    fi
    PROGRESS_BAR_LENGTH=$4
    echo -e -n "$GREENBEGIN 0 $COLOREND kB ["
    for ((i=0; i<$(($FILE_KILOBYTES* $PROGRESS_BAR_LENGTH / $MAX_KILOBYTES)); i++)); do
        echo -n "="
    done
    echo -n ">"
    for ((i=$(($FILE_KILOBYTES* $PROGRESS_BAR_LENGTH / $MAX_KILOBYTES)); i<$PROGRESS_BAR_LENGTH; i++)); do
        echo -n " "
    done
    echo -n -e "] $REDBEGIN$MAX_KILOBYTES$COLOREND kB"

    echo -e "\e[1;37m"
    echo
    return
}



echo "wakeup"
echo $PATH
echo "setting up cmake env"

cmake ./ -G"Unix Makefiles" -S"src" -B"build"

echo "building your project"

cmake --build build
# display filesize of the library
#sizeBar "the library" "500" "./bin/libev3dev-cpp-template-wrapper.a" "50"
# display filesize of the examples
#sizeBar "spin_a_motor.elf" "500" "./bin/examples/spin_a_motor/spin_a_motor.elf" "50"
#mkdir "./bin/finished/"
#cp "./bin/examples/spin_a_motor/spin_a_motor.elf" "./bin/finished/spin_a_motor.elf"
#sizeBar "move_until_distance.elf" "500" "./bin/examples/move_until_distance/move_until_distance.elf" "50"
#echo "start of program"
#qemu-arm-static -L /usr/arm-linux-gnueabi/ ./sentFiles/ev3MotorTest.elf
#echo "end of program"