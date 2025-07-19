# Additional clean files
cmake_minimum_required(VERSION 3.16)

if("${CONFIG}" STREQUAL "" OR "${CONFIG}" STREQUAL "Debug")
  file(REMOVE_RECURSE
  "CMakeFiles/appTeam02_DigitalTripBook_autogen.dir/AutogenUsed.txt"
  "CMakeFiles/appTeam02_DigitalTripBook_autogen.dir/ParseCache.txt"
  "appTeam02_DigitalTripBook_autogen"
  )
endif()
