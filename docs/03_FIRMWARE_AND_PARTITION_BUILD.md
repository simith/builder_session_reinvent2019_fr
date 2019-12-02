# Factory Provisioning

The factory provisioning of the ESP32 module involves provisioning it with AWSI IoT certificates, keys, Code signing certificate and any other configuration that you would like to provide to the Device.

## The Partition Table

```
# Name,   Type, SubType, Offset,  Size, Flags
nvs,      data, nvs,     0x10000,  0x6000
otadata,  data, ota,     0x16000,  0x2000
phy_init, data, phy,     0x18000,  0x1000
ota_0,    0,    ota_0,   0x20000,  1500K
ota_1,    0,    ota_1,   ,         1500K
storage,  data, nvs,     ,         0x10000
```

The above partition table represents 2 OTA partitions and (ota_0 and ota_1) and a NVS (non-volatile storage) ***storage*** partition for storing certificates and configuration. The production firmware is flashed at ota_0 in the factory. As you deploy your updates the firmware images will be written to ota_1 and ota_0 based on which is the primary at that point. Amazon FreeRTOS has a few conventions that you can use to program certificates, keys, code-signing certificates, Just-in-time Registration certificates etc. so that it makes it easy to program thises devices with the required configuration. If you abide by those conventions, everything should work as expected when Amazon FreeRTOS looks for the configuration it on the flash or filesystem.


### Converting certificates from PEM to DER

In order to flash in the certificates into the storage area, we will first convert into binary (.DER) format. To do this we will run **./conv_pem_to_der.sh** from the _builder_session_reinvent2019_fr/workshop/tools/_ directory.

```
$ ./conv_pem_to_der.sh
Converting Certificate, Private Key and Code Signing Key from PEM to DER format
writing RSA key
```

As a result, three DER files have been created.

1. privatekey.der (Converted from privatekey.pem)
2. cert.der (Converted from cert.pem)
3. csk.der (Converted from ecdsasigner.crt)

### Generating storage partition

We are not going to store the Certificate, private key and Code siging certificate in the header file or as a part of the source code of the firmware, as that is not going to be a scalable way of doing things in the factory. Hence, we need to write this configuration seperately to flash during production. 

We retrieved the Certificate and Private key from AWS IoT (Amazon CA issued certificates) for this workshop, however, in production, it is not considered to be a good practise to download private key over the wire and store it on the disk. In such situations Just-in-time Registration/Just-in-time Provisioning flows needs to be used, where the certificate can be provisioned on the device and a CSR can be sent out which will be signed by the CA (on the Factory PC) and the Certificate returned back to the device, this way the Private key never leaves the device.

JITP flow: https://aws.amazon.com/blogs/iot/setting-up-just-in-time-provisioning-with-aws-iot-core/

To generate the storage partition, we use the Espressif NVS Partition Generator tool. This tools is located in the _builder_session_reinvent2019_fr\workshop\amazon-freertos\vendors\espressif\esp-idf\components\nvs_flash\nvs_partition_generator_ directory. The partition layout is defined in **partiton.csv** file.

The configuration we will write into the storage partition looks like the below,

![Firmware Client Update](ws_partition_layout.png?raw=true)

The partition.csv file is located in the **amazon-freertos/vendors/espressif/esp-idf/components/nvs_flash/nvs_partition_generator**

```
key,type,encoding,value
creds,namespace,,
P11_Cert,file,binary,testdata/cert.der
P11_Key,file,binary,testdata/privatekey.der
P11_CSK,file,binary,testdata/csk.der
```
Esentially, the certificate, key, code signing certificate which we converted to DER format is being packaged into a binary file to be stored on on the nvs storage partition.

In order to simplify, execute the command **./create_partition.sh** from the _builder_session_reinvent2019_fr/workshop/tools/_ directory. You will get the following:

```
$ ./create_partition.sh 
Copying Certificate, Private Key and Code Signing Key
Creating partition.bin with Key, Device Certificate and Code Signing Certificate
python nvs_partition_gen.py --version v2 input partition.csv output partition.bin
row[key]{'type': 'namespace', 'value': '', 'key': 'creds', 'encoding': ''}
row[key]{'type': 'file', 'value': 'testdata/cert.der', 'key': 'P11_Cert', 'encoding': 'binary'}
row[key]{'type': 'file', 'value': 'testdata/privatekey.der', 'key': 'P11_Key', 'encoding': 'binary'}
row[key]{'type': 'file', 'value': 'testdata/csk.der', 'key': 'P11_CSK', 'encoding': 'binary'}
Copying partition.bin to workshop/tools/bin directory
partition.bin is ready for download.
```

This command invokes the NVS Partition Generator tool and create **partition.bin** file. Please explore the contents of the command **./create_partition.sh**.

## Update the Firmware code with the IoT Endpoint, Thing name and Wi-fi credentials

Before building the factory firmware image, we need to update the firmware image with the AWS IoT Endpoint, Thing name of the Thing your script just created and Wi-Fi credentials. Ideally, IoT Endpoint information can go into the storage partition as part of the configuration, however, for the purposes of this workshop let us update the file **aws_clientcredential.h** with the endpoint information as shown below. **This approach is not recommended for Production**. The information that you need to fill in are in the subsection below.

 ![Firmware Client Update](ws_client_credential_update.png?raw=true)

We are going to use the Amazon FreeRTOS OTA demo for this workshop. You can find the OTA Demo code in the demos directory of Amazon FreeRTOS git repository.

### AWS IoT Endpoint

To get you AWS IoT endpoint, execute the following command,

```
$ aws iot describe-endpoint --endpoint-type iot:Data-ATS --region us-west-2
{
    "endpointAddress": "xxxxxxxxxxxxx-ats.iot.us-west-2.amazonaws.com"
}
```

Update **clientcredentialMQTT_BROKER_ENDPOINT** in `aws_clientcredential.h` with the `endpointAddress` value.

### Thing Name

The output of **./create_thing.sh** should have provided you with a Thing name which you have noted down, or you can still find it in the tools directory in the file **thingName**.

### Wi-Fi credentials

The instructor will provide you with the Wi-Fi credentials for the workshop, you could use an available Wi-Fi access point for this demo, even your mobile hotspot.

## Build

Before we build. let us make sure the toolchain path is setup in the PATH environment variable, the install.sh script in the repo's workshop/tools floder has been used to setup the toolchain, we need tp make it avaiable in the PATH for the shell you are on. Let us do that by executing the following command,

```
$ . ~/.bash_profile
```

We are now set to build the code. Now from the _amazon-freeRTOS_ directory under tools,

```
amazon-freertos $ /snap/bin/cmake  -DVENDOR=espressif -DBOARD=esp32_wrover_kit  -DCOMPILER=xtensa-esp32 -B build
```

The last few lines of the output should be as follows:

```
=========================================================================

-- Configuring done
-- Generating done
-- Build files have been written to: /home/ubuntu/environment/builder_session_reinvent2019_fr/workshop/amazon-freertos/build
```

This will create the build file in the build directory for us to build the firmware image.

From the **build** directory, execute the make command,

```
build $ make
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

1. Setup the esptool (https://docs.espressif.com/projects/esp-idf/en/v3.1.5/get-started-cmake/index.html#get-started-setup-toolchain-cmake)

If you have Python installed, the below command should do the job,

```
pip install esptool
```

2. Execute the **get_bin.sh** script from the **workshop/tools** to get all built binaries into the bin folder.

```
$ ./get_bin.sh
Copied partition-table.bin,bootloader.bin,ota_data_initial.bin and firmware.bin to ./bin folder
```

## Download the Firmware and configuration from Cloud9

We are now all set to download the .bin files to your laptop and start flashing the binaries to the ESP32 MCU. From the workshop/tools/bin folder download the .bin files to you laptop as shown below,

![Firmware Client Update](ws_binary_download.png?raw=true)


## Flash configuration (From Laptop)

Please make sure the **esptool.py** is in the path before executing the next command,

Let us erase the flash first before writing the firmware and configuration,


```
$ esptool.py write_flash 0x317000  partition.bin
```

Flash address `0x317000` address in flash is where the storage partition is located. The **partition.bin** has the Certificate, Key and Code signing certificate. You could use it to store more configuration information like IoT endpoint, and application specific configuration.


## Flash Firmware (From Laptop)

Please make sure the **esptool.py** is in the path before executing the next command,

```
$  esptool.py --chip esp32 -p [PORT] -b 460800 write_flash --flash_mode dio --flash_freq 40m --flash_size 4MB 0x1000 bootloader.bin 0x8000 partition-table.bin 0x16000 ota_data_initial.bin 0x20000 firmware.bin 
```

## Monitor the ESP32 (From Laptop)

Now we can connect to the COM port with baud rate 115200, 8-bit, No-Parity, 1-stop bit to monitor.
For Mac users, use the screen command,

```
$ screen /dev/cu.SLAB_USBtoUART 115200
```

Windows users can use the Putty terminal software or TeraTerm.

| [Previous section](./02_AWS_IOT_SETUP.md) | [Main](../README.md) | [Next section](./04_OTA_SETUP.md) |
