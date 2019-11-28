
## Factory provisioning
The factory provisioning of the ESP32 module involved provisioning it with AWSI IoT certificates, keys, Code signing certificate and any other configuration that you would like to provide to the Device.

## The partition table 

```
# Name,   Type, SubType, Offset,  Size, Flags
nvs,      data, nvs,     0x10000,  0x6000
otadata,  data, ota,     0x16000,  0x2000
phy_init, data, phy,     0x18000,  0x1000
ota_0,    0,    ota_0,   0x20000,  1500K
ota_1,    0,    ota_1,   ,         1500K
storage,  data, nvs,  ,         0x10000
```

The above partition table represents 2 OTA partitions and (ota_0 and ota_1) and a NVS (non-vlatile storage) ***storage*** partition for storing certificates and configuration. The production firmware is flashed at ota_0. You can use code signing through the AWS IoT Device Management console to sign your code images before deploying them using an over-the-air (OTA) update job.

## Update the Firmware code with the IoT Endpoint,Thing name and Wi-fi credentials

Before building the factory firmware image, we need to update the firmware image with the AWS IoT Endpoint,Thing name of the Thing your script just created and Wi-Fi credentials. Ideally, IoT Endpoint information can go into the storage partition as part of the configuration, however, for the purposes of this workshop let us update the file **aws_clientcredential.h** with the endpoint information. **This approach is not recommended for Production**.

We are going to use the Amazon FreeRTOS ota demo for this workshop. You can find the OTA Demo code in the demos directory of Amazon FreeRTOS git repository,

### AWS IoT Endpoint

To get you AWS IoT endpoint, execute the following command,

```
$aws iot describe-endpoint --endpoint-type iot:Data-ATS --region us-west-2
{
    "endpointAddress": "xxxxxxxxxxxxx-ats.iot.us-west-2.amazonaws.com"
}
```

### Thing name

The output of ./setup.sh should have provided you with a Thing name which you have noted down, or you can still find it in the tools directory in the file **thingName**.

### Wi-Fi credentials

The instructor will provide you with the Wi-Fi credentials for the workshop, you could use an available Wi-Fi access point for this demo, even your mobile hotspot.


Update the AWS IoT Endpoint,Thing name and Wi-fi credentials in the "aws_clientcredentials.h" file as shown below.

![](ws_client_credential_update.png)


## Build 

We are now set to build the code, from the amazon-freertos directory under tools,

```
amazon-freertos$ /snap/bin/cmake  -DVENDOR=espressif -DBOARD=esp32_wrover_kit  -DCOMPILER=xtensa-esp32 -B build
```

This will create make files in the **build** directory for us to build the firmware image.

From the **build** directory in **amazon-freertos**, execute the make command,

```
build$ make
```
If everything went well, you should see an output like the following,

```
[ 90%] Linking C static library libbootloader_support.a
[ 90%] Built target idf_component_bootloader_support
Scanning dependencies of target bootloader.elf
[ 92%] Building C object CMakeFiles/bootloader.elf.dir/dummy_main_src.c.obj
[ 95%] Linking C executable bootloader.elf
[ 97%] Built target bootloader.elf
Scanning dependencies of target bootloader
[100%] Generating ../bootloader.bin
esptool.py v2.6
[100%] Built target bootloader
[100%] No install step for 'bootloader'
[100%] Completed 'bootloader'
[100%] Built target bootloader
Scanning dependencies of target blank_ota_data
[100%] Generating ../../ota_data_initial.bin
[100%] Built target blank_ota_data
```



## Setup your Laptop for flashing firmware and configuration

1. Setup the Toolchain (https://docs.espressif.com/projects/esp-idf/en/v3.1.5/get-started-cmake/index.html#get-started-setup-toolchain-cmake)



## Download the Firmware and configuration from Cloud9



## Flash configuration (From Laptop)


## Flash Firmware (From Laptop)


## Monitor the ESP32 (From Laptop)


