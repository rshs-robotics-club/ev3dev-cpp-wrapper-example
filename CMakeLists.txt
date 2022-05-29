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

cmake_minimum_required(VERSION 3.1.0)

set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR arm)
set(CMAKE_C_COMPILER "arm-linux-gnueabi-gcc")
set(CMAKE_CC_COMPILER "arm-linux-gnueabi-gcc")
set(CMAKE_CXX_COMPILER "arm-linux-gnueabi-g++")
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED true)



add_subdirectory(ev3dev-cpp-template-wrapper .${CURRENT_SOURCE_DIR}/ev3dev-cpp-template-wrapper/bin)
set(YOUR_PROJECT_FINISHED_DIR ${CMAKE_SOURCE_DIR}/bin)

function (buildExecutable filePath)
    get_filename_component(fileName ${filePath} NAME_WE)
    project(${fileName}_EXECUTABLE VERSION 1.0.0)
    add_executable(${PROJECT_NAME} ${filePath})
    set_target_properties(
        ${PROJECT_NAME}
        PROPERTIES
        OUTPUT_NAME ${PROJECT_NAME}.elf
    )
    add_custom_target(
        ${PROJECT_NAME}_TARGET
        ALL
    )
    add_dependencies(${PROJECT_NAME}_TARGET LIB_BUILT_TARGET)
    add_dependencies(${PROJECT_NAME}_TARGET ${PROJECT_NAME})
    target_link_libraries(${PROJECT_NAME} ev3-cpp-template-wrapper-lib)
    add_custom_command(
        TARGET ${PROJECT_NAME}_TARGET POST_BUILD
        COMMAND sudo mkdir -p ${YOUR_PROJECT_FINISHED_DIR}
        COMMAND sudo cp ${PROJECT_BINARY_DIR}/${PROJECT_NAME}.elf  ${YOUR_PROJECT_FINISHED_DIR}/${PROJECT_NAME}.elf
        COMMAND sudo bash ${CMAKE_CURRENT_SOURCE_DIR}/scripts/post_build.sh ${PROJECT_NAME}.elf 500 ${YOUR_PROJECT_FINISHED_DIR}/${PROJECT_NAME}.elf 50
    )
endfunction()

file(GLOB files "./src/*.cpp")
foreach(file ${files})
    buildExecutable(${file})
endforeach()
# project(example_project_name VERSION 1.0)


# add_executable(
#     ${PROJECT_NAME}
#     src/main.cpp
# )

# set_target_properties(
#     ${PROJECT_NAME}
#     PROPERTIES
#     OUTPUT_NAME ${PROJECT_NAME}.elf
# )



# set(YOUR_PROJECT_FINISHED_DIR ${CMAKE_CURRENT_SOURCE_DIR}/bin)

# add_custom_target(
#     ${PROJECT_NAME}_TARGET
#     ALL
# )

# add_dependencies(${PROJECT_NAME}_TARGET LIB_BUILT_TARGET)
# add_dependencies(${PROJECT_NAME}_TARGET ${PROJECT_NAME})
# target_link_libraries(${PROJECT_NAME} ev3-cpp-template-wrapper-lib)
# add_custom_command(
#     TARGET ${PROJECT_NAME}_TARGET POST_BUILD
#     COMMAND sudo mkdir -p ${YOUR_PROJECT_FINISHED_DIR}
#     COMMAND sudo cp ${PROJECT_BINARY_DIR}/${PROJECT_NAME}.elf  ${YOUR_PROJECT_FINISHED_DIR}/${PROJECT_NAME}.elf
#     COMMAND sudo bash ${CMAKE_CURRENT_SOURCE_DIR}/scripts/post_build.sh ${PROJECT_NAME}.elf 500 ${YOUR_PROJECT_FINISHED_DIR}/${PROJECT_NAME}.elf 50
# )