file(REMOVE_RECURSE
  "../aws_demos.bin"
  "../bootloader/bootloader.bin"
  "../bootloader/bootloader.elf"
  "../bootloader/bootloader.map"
  "../config/sdkconfig.cmake"
  "../config/sdkconfig.h"
  "CMakeFiles/app"
)

# Per-language clean rules from dependency scanning.
foreach(lang )
  include(CMakeFiles/app.dir/cmake_clean_${lang}.cmake OPTIONAL)
endforeach()
