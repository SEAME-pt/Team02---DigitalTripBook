# Additional clean files
cmake_minimum_required(VERSION 3.16)

if("${CONFIG}" STREQUAL "" OR "${CONFIG}" STREQUAL "Debug")
  file(REMOVE_RECURSE
  "CMakeFiles/appDigitalTripBook_autogen.dir/AutogenUsed.txt"
  "CMakeFiles/appDigitalTripBook_autogen.dir/ParseCache.txt"
  "appDigitalTripBook_autogen"
  )
endif()
