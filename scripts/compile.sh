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


CONTAINER_NAME="EV3PROGRAM"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
SRC_DIR=${SCRIPT_DIR}/../
winpty docker rm ${CONTAINER_NAME}
winpty docker run -it --entrypoint /${SRC_DIR}/scripts/runWithinContainer.sh --name ${CONTAINER_NAME} -v /${SRC_DIR}:/${SRC_DIR} -w /${SRC_DIR} ev3cc
$SHELL