(python /Users/simithn/Downloads/AmazonFreeRTOS3/vendors/espressif/esp-idf/components/esptool_py/esptool/esptool.py \
  read_flash 0x9000 0xc00 /dev/fd/3 >&2) 3>&1|python \
  /Users/simithn/Downloads/AmazonFreeRTOS3/vendors/espressif/esp-idf/components/partition_table/gen_esp32part.py /dev/fd/0
