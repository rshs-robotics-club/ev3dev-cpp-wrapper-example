#!/bin/bash
# 
#    A bash script used with Docker for compiling The Ev3dev C++ Wrapper Library examples
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
    BYTES_PER_KILOBYTE="1000"
    FILE_KILOBYTES=$(($FILESIZE/$BYTES_PER_KILOBYTE))
    MAX_KILOBYTES=$2
    INVERSEBEGIN="\e[0;32m"
    INVERSEEND="\e[1;37m"
    echo
    echo -e "$INVERSEBEGIN$FILENAME$INVERSEEND's size is $INVERSEBEGIN$FILE_KILOBYTES$INVERSEEND kilobytes out of the $INVERSEBEGIN$MAX_KILOBYTES$INVERSEEND kilobytes allowed"
    if (($FILE_KILOBYTES > $MAX_KILOBYTES)); then
        echo "The file is $INVERSEBEGIN $(($FILE_KILOBYTES - $MAX_KILOBYTES)) $INVERSEEND kilobytes too large"
        echo
        return
    fi
    echo -e -n "\e[0;32m" # set the color to green
    PROGRESS_BAR_LENGTH=$4
    echo -n "0 kB ["
    for ((i=0; i<$(($FILE_KILOBYTES* $PROGRESS_BAR_LENGTH / $MAX_KILOBYTES)); i++)); do
        echo -n "="
    done
    echo -n ">"
    for ((i=$(($FILE_KILOBYTES* $PROGRESS_BAR_LENGTH / $MAX_KILOBYTES)); i<$PROGRESS_BAR_LENGTH; i++)); do
        echo -n " "
    done
    echo -n "] $MAX_KILOBYTES kB"

    echo -e "\e[1;37m \n"
    return
}

# actual code begins here
sizeBar $1 $2 $3 $4