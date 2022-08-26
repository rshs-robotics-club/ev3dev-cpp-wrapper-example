#!/usr/bin/env bash
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

# some presets ---------------------------------------------------------------------------
containerName="EV3PROGRAM"
scriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
srcDir=${scriptDir}/../

entrypointCMD="/${scriptDir}/runWithinContainer.sh"

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    docker rm ${containerName}
    docker run --entrypoint ${entrypointCMD} --name ${containerName} -v /${srcDir}:/${srcDir} -w /${srcDir} eisverygoodletter/debian-stretch-cross $@
elif [[ "$OSTYPE" == "darwin"* ]]; then
    docker rm ${containerName}
    docker run --entrypoint ${entrypointCMD} --name ${containerName} -v /${srcDir}:/${srcDir} -w /${srcDir} eisverygoodletter/debian-stretch-cross $@
else
    winpty docker rm ${containerName}
    winpty docker run --entrypoint ${entrypointCMD} --name ${containerName} -v /${srcDir}:/${srcDir} -w /${srcDir} eisverygoodletter/debian-stretch-cross $@
fi
$SHELL