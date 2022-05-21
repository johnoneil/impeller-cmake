set(TOOLS_DIR ${FLUTTER_ENGINE_DIR}/impeller/tools)

# xxd(
#    OUTPUT_HEADER filename
#    OUTPUT_SOURCE filename
#    SOURCE filename
#    ...
# )
# See `impellerc_parse` below for the full set of inputs.
function(xxd)
    cmake_parse_arguments(ARG
        "" "OUTPUT_HEADER;OUTPUT_SOURCE;SOURCE" "" ${ARGN})
    blobcat_parse(CLI
        SYMBOL_NAME ${ARG_SYMBOL_NAME}
        OUTPUT_HEADER ${ARG_OUTPUT_HEADER}
        OUTPUT_SOURCE ${ARG_OUTPUT_SOURCE}
        ${ARG_UNPARSED_ARGUMENTS})
    get_filename_component(OUTDIR "${ARG_OUTPUT_SOURCE}" ABSOLUTE)
    get_filename_component(OUTDIR "${OUTDIR}" DIRECTORY)
    add_custom_command(OUTPUT ${ARG_OUTPUT}
        COMMAND ${CMAKE_COMMAND} -E make_directory "${OUTDIR}"
        COMMAND "python ${TOOLS_DIR}/xxd.py" ${CLI}
        MAIN_DEPENDENCY ${ARG_SOURCE}
        BYPRODUCTS ${OUTPUT_HEADER} ${OUTPUT_SOURCE}
        COMMENT "Dumping translation unit ${ARG_OUTPUT_SOURCE}"
        WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}")
endfunction()

# xxd_parse(
#    SYMBOL_NAME name
#    OUTPUT_HEADER filename
#    OUTPUT_SOURCE filename
#    SOURCE filename
# )
function(xxd_parse CLI_OUT)
    cmake_parse_arguments(ARG
        "" "SYMBOL_NAME;OUTPUT_HEADER;OUTPUT_SOURCE;SOURCE" "" ${ARGN})
    set(CLI "")

    # --symbol-name
    if(ARG_SYMBOL_NAME)
        list(APPEND CLI "--symbol-name" "${ARG_SYMBOL_NAME}")
    endif()

    # --output-header
    if(ARG_OUTPUT_HEADER)
        list(APPEND CLI "--output-header" "${ARG_OUTPUT_HEADER}")
    endif()

    # --output-source
    if(ARG_OUTPUT_SOURCE)
        list(APPEND CLI "--output-source" "${ARG_OUTPUT_SOURCE}")
    endif()

    # --source
    if(ARG_SOURCE)
        list(APPEND CLI "--source" "${ARG_SOURCE}")
    endif()

    set(${CLI_OUT} ${CLI} PARENT_SCOPE)
endfunction()
