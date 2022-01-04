cmake_minimum_required(VERSION 3.18.1)
set(PROJECT_NAME "xinlake_qrcode")
project(${PROJECT_NAME} LANGUAGES CXX)

# This value is used when generating builds using this plugin, so it must
# not be changed
set(PLUGIN_NAME "xinlake_qrcode_plugin")

add_library(${PLUGIN_NAME} SHARED
  "xinlake_qrcode_plugin.cpp"
  "zxing_decode.cpp"
)
apply_standard_settings(${PLUGIN_NAME})
set_target_properties(${PLUGIN_NAME} PROPERTIES
  CXX_VISIBILITY_PRESET hidden)
target_compile_definitions(${PLUGIN_NAME} PRIVATE FLUTTER_PLUGIN_IMPL)
target_include_directories(${PLUGIN_NAME} INTERFACE
  "${CMAKE_CURRENT_SOURCE_DIR}/include")
  
add_custom_command(TARGET ${PLUGIN_NAME}
    PRE_BUILD
    COMMAND nuget install xinlake.zxing.native -Version 1.2.0 -OutputDirectory "${CMAKE_CURRENT_SOURCE_DIR}/packages"
)

target_include_directories(${PLUGIN_NAME} PRIVATE
  "${CMAKE_CURRENT_SOURCE_DIR}/packages/xinlake.zxing.native.1.2.0/lib/native/lib-zxing"
  "${CMAKE_CURRENT_SOURCE_DIR}/packages/xinlake.zxing.native.1.2.0/lib/native/lib-stb")

target_link_libraries(${PLUGIN_NAME} PRIVATE 
  flutter flutter_wrapper_plugin
  "${CMAKE_CURRENT_SOURCE_DIR}/packages/xinlake.zxing.native.1.2.0/lib/native/zxing-x64.$<CONFIG>.lib"
)

# List of absolute paths to libraries that should be bundled with the plugin
set(xinlake_qrcode_bundled_libraries
  ""
  PARENT_SCOPE
)
