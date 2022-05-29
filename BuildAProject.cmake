
function (buildExecutable fileName)
    project(${fileName}_EXECUTABLE VERSION 1.0.0)
    add_executable(${PROJECT_NAME} ${fileName})
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

