
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
Update **clientcredentialMQTT_BROKER_ENDPOINT** in aws_clientcredential.h with the endpointAddress value.

### Thing name

The output of ./setup.sh should have provided you with a Thing name which you have noted down, or you can still find it in the tools directory in the file **thingName**.

### Wi-Fi credentials

The instructor will provide you with the Wi-Fi credentials for the workshop, you could use an available Wi-Fi access point for this demo, even your mobile hotspot.

## Build 

We are now set to build the code, from the amazon-freertos directory under tools,

```
amazon-freertos$ /snap/bin/cmake  -DVENDOR=espressif -DBOARD=esp32_wrover_kit  -DCOMPILER=xtensa-esp32 -B build
```

This will create the build file in the build directory for us to build the firmware image.

From the build directory, execute the make command,

```
/snap/bin/cmake  -DVENDOR=espressif -DBOARD=esp32_wrover_kit  -DCOMPILER=xtensa-esp32 -B build
```






