cmake_minimum_required(VERSION 3.1.0)

set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR arm)
set(CMAKE_C_COMPILER "arm-linux-gnueabi-gcc")
set(CMAKE_CC_COMPILER "arm-linux-gnueabi-gcc")
set(CMAKE_CXX_COMPILER "arm-linux-gnueabi-g++")
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED true)



add_subdirectory(ev3dev-cpp-template-wrapper .${CURRENT_SOURCE_DIR}/ev3dev-cpp-template-wrapper/bin)

project(example_project_name VERSION 1.0)


add_executable(
    ${PROJECT_NAME}
    src/main.cpp
)

set_target_properties(
    ${PROJECT_NAME}
    PROPERTIES
    OUTPUT_NAME ${PROJECT_NAME}.elf
)



set(YOUR_PROJECT_FINISHED_DIR ${CMAKE_CURRENT_SOURCE_DIR}/bin/)

add_custom_target(
    ${PROJECT_NAME}_TARGET
    ALL
)

add_dependencies(${PROJECT_NAME}_TARGET LIB_BUILT_TARGET)
add_custom_command(
    TARGET ${PROJECT_NAME}_TARGET POST_BUILD
    COMMAND cp ${PROJECT_BINARY_DIR}/${PROJECT_NAME}.elf  ${YOUR_PROJECT_FINISHED_DIR}/${PROJECT_NAME}.elf
    COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/scripts/post_build.sh ${PROJECT_NAME}.elf 500 ${YOUR_PROJECT_FINISHED_DIR}/${PROJECT_NAME}.elf 50
)