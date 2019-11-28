ESP_IDF=$WORKSHOP_ROOT_DIR/workshop/amazon-freertos/vendors/espressif/esp-idf
WORKSHOP_TOOLS_DIR=$WORKSHOP_ROOT_DIR/workshop/tools
WORKSHOP_FREERTOS_DIR=$WORKSHOP_ROOT_DIR/workshop/amazon-freertos
WORKSHOP_NVS_PARTITION_FLASHER_TOOL_DIR=$WORKSHOP_FREERTOS_DIR/vendors/espressif/esp-idf/components/nvs_flash/nvs_partition_generator
WORKSHOP_PARTITION_WRITER_DIR=$WORKSHOP_NVS_PARTITION_FLASHER_TOOL_DIR/testdata

echo "Copying Certificate, Private Key and Code Signing Key"
cp privatekey.der cert.der csk.der ${WORKSHOP_PARTITION_WRITER_DIR}
cp partition.csv ${WORKSHOP_NVS_PARTITION_FLASHER_TOOL_DIR}
cd ${WORKSHOP_NVS_PARTITION_FLASHER_TOOL_DIR}

echo "Creating partition.bin with Key, Device Certificate and Code Signing Certificate"

echo python nvs_partition_gen.py --version v2 input partition.csv output partition.bin
python nvs_partition_gen.py --version v2 --input partition.csv --output partition.bin

echo "Copying partition.bin to Workshop Tools directory"
mv partition.bin ${WORKSHOP_TOOLS_DIR}/bin/partition.bin

cd ${WORKSHOP_PARTITION_WRITER_DIR}
rm privatekey.der cert.der csk.der

cd ${WORKSHOP_TOOLS_DIR}
echo "partition.bin is ready for download."
