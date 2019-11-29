WORKSHOP_TOOLS_DIR=$WORKSHOP_ROOT_DIR/workshop/tools
WORKSHOP_FREERTOS_DIR=$WORKSHOP_ROOT_DIR/workshop/amazon-freertos

cp $WORKSHOP_FREERTOS_DIR/build/bootloader/bootloader.bin $WORKSHOP_TOOLS_DIR/bin/
cp $WORKSHOP_FREERTOS_DIR/build/partition_table/partition-table.bin $WORKSHOP_TOOLS_DIR/bin/
cp $WORKSHOP_FREERTOS_DIR/build/aws_demos.bin $WORKSHOP_TOOLS_DIR/bin/firmware.bin
cp $WORKSHOP_FREERTOS_DIR/build/ota_data_initial.bin $WORKSHOP_TOOLS_DIR/bin/ota_data_initial.bin

echo "Copied partition-table.bin,bootloader.bin,ota_data_initial.bin and firmware.bin to ./bin folder"
