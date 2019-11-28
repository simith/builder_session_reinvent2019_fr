ESP_IDF=$WORKSHOP_ROOT_DIR/workshop/amazon-freertos/vendors/espressif/esp-idf
WORKSHOP_TOOLS_DIR=$WORKSHOP_ROOT_DIR/workshop/tools
WORKSHOP_FREERTOS_DIR=$WORKSHOP_ROOT_DIR/workshop/amazon-freertos
WORKSHOP_NVS_PARTITION_FLASHER_TOOL_DIR=$WORKSHOP_FREERTOS_DIR/vendors/espressif/esp-idf/components/nvs_flash/nvs_partition_generator
WORKSHOP_PARTITION_WRITER_DIR=$WORKSHOP_NVS_PARTITION_FLASHER_TOOL_DIR/testdata

echo "Copying Certificate, Private Key and Code Signing Key to ${WORKSHOP_PARTITION_WRITER_DIR}"
cp privatekey.der cert.der csk.der ${WORKSHOP_PARTITION_WRITER_DIR}
cd ${WORKSHOP_NVS_PARTITION_FLASHER_TOOL_DIR}

echo "Creating partition.bin with Key, Device Certificate and Code Signing Certificate"
python nvs_partition_gen.py  --version v2 input partition.csv output ${WORKSHOP_PARTITION_WRITER_DIR}/partition.bin

echo "Copying partition.bin in ${WORKSHOP_PARTITION_WRITER_DIR} to Workshop Tools directory ${WORKSHOP_TOOLS_DIR}"
cp ${WORKSHOP_PARTITION_WRITER_DIR}/partition.bin ${WORKSHOP_TOOLS_DIR}/partition.bin

echo "partition.bin copied to ${WORKSHOP_TOOLS_DIR}, ready for download"
