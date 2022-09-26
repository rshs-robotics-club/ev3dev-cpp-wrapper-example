# 
#    A CMake file used with Docker for compiling The Ev3dev C++ Wrapper Library template
#
#    Copyright (c) 2021, 2022 - Eisverygoodletter
#
#    This file is part of The Ev3dev C++ Wrapper Library template.
#    The Ev3dev C++ Wrapper Library template is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by the Free Software Foundation, 
#    either version 3 of the License, or (at your option) any later version.
#    The Ev3dev C++ Wrapper Library template is distributed in the hope that it will be useful, 
#    but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or 
#    FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
#    You should have received a copy of the GNU General Public License 
#    along with The Ev3dev C++ Wrapper Library. If not, see <https://www.gnu.org/licenses/>.

cmake_minimum_required(VERSION 3.24.0)

set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR arm)
set(CMAKE_C_COMPILER "arm-linux-gnueabi-gcc")
set(CMAKE_CC_COMPILER "arm-linux-gnueabi-gcc")
set(CMAKE_CXX_COMPILER "arm-linux-gnueabi-g++")
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED true)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

add_subdirectory(ev3dev-cpp-template-wrapper .${CURRENT_SOURCE_DIR}/ev3dev-cpp-template-wrapper/bin)

project(container_project VERSION 3.0.1)
add_compile_options(${OPTIMIZATION_LEVEL})
add_compile_options(-fpermissive)
file(GLOB files "./src/*.cpp")
file(GLOB tempLinkFiles "./src/templinks/*.cpp")
set(YOUR_PROJECT_FINISHED_DIR ${CMAKE_CURRENT_SOURCE_DIR}/bin)

foreach(file ${files})
    get_filename_component(fileName ${file} NAME_WE)
    add_executable(${fileName}_EXECUTABLE ${file} ${tempLinkFiles})
    set(YOUR_PROJECT_FINISHED_DIR ${CMAKE_CURRENT_SOURCE_DIR}/bin)
    target_include_directories(${fileName}_EXECUTABLE PRIVATE "./src/templinks/")
    target_link_libraries(${fileName}_EXECUTABLE PRIVATE ev3-cpp-template-wrapper-lib)
    
    set_target_properties(
        ${fileName}_EXECUTABLE
        PROPERTIES
        OUTPUT_NAME ${fileName}.elf
    )
    add_custom_command(
        TARGET ${fileName}_EXECUTABLE POST_BUILD
        COMMAND sudo mkdir -p ${YOUR_PROJECT_FINISHED_DIR}
        COMMAND sudo cp ${PROJECT_BINARY_DIR}/${fileName}.elf  ${YOUR_PROJECT_FINISHED_DIR}/${fileName}.elf
    )
    if (${VERBOSE}) 
        add_custom_target(
            ${fileName}_TARGET
            ALL
        )
        add_dependencies(${fileName}_TARGET LIB_BUILT_TARGET)
        add_dependencies(${fileName}_TARGET ${fileName}_EXECUTABLE)
        add_custom_command(
            TARGET ${fileName}_TARGET POST_BUILD
            COMMAND sudo bash ${CMAKE_CURRENT_SOURCE_DIR}/scripts/post_build.sh ${fileName}.elf 500 ${YOUR_PROJECT_FINISHED_DIR}/${fileName}.elf 50
        )
    endif()
endforeach()