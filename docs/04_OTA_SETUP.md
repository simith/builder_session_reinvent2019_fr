# OTA Setup

## Build the new firmware to fix the

### 1. Let us fix the Bug

We now need to make some code changes to get the GREEN light flashing instead of the RED light,build the firmware and deploy it to the Kakematic device. The changes need to be done in the **ota** directory of **demos** in the file **aws_iot_ota_demo.c**,

The path to the file within amazon-freertos will be as shown below,

```
amazon-freertos/demos/ota
```

![OTA Red to Green](ws_ota_red_to_green.png?raw=true)

At the end of the file there is a function named **pBlinkOnCakeReady**, this is esentially the task that runs when a cake is fully baked.

```
static void pBlinkOnCakeReady(void *pParam)
{
    uint32_t xGpioPin = GPIO_RED;

    vTaskDelay(10000 / portTICK_PERIOD_MS);
    gpio_pad_select_gpio(GPIO_RED);
    /* Set the GPIO as a push/pull output */
    gpio_set_direction(GPIO_RED, GPIO_MODE_OUTPUT);

    while (1)
    {
        /* Blink off (output low) */
        printf("Turning off the LED\n");
        gpio_set_level(xGpioPin, 0);
        vTaskDelay(500 / portTICK_PERIOD_MS);
        /* Blink on (output high) */
        printf("Turning on the LED\n");
        gpio_set_level(xGpioPin, 1);
        vTaskDelay(500 / portTICK_PERIOD_MS);
    }
}

```

We need to modify the line which sets the xGpioPin variable from GPIO_RED to GPIO_GREEN. Alternatively, if this was part of the Application configuration on what LED needs to blink on cake ready, this information could have been updated via an OTA Custom job which in turn would update the NVS storage partition which we are currently using only for storing certificate, keys and other configuration. That is left as an exercise to the participants.

Let us go ahead and make the code changes,

```
uint32_t xGpioPin = GPIO_GREEN;
```

### 2. Update Version Number

Amazon FreeRTOS compares the build version of the current running firmware to the one received via an OTA update. The build number should be higher than the firmware running on the MCU currently to update the firmware to the new version, hence we need to update the BUILD_VERSION_NUMBER as well.

![Build version change](ws_app_version_change.png?raw=true)

Let us increment the version change from version 5 to version 6.

```
#define APP_VERSION_MAJOR 0
#define APP_VERSION_MINOR 9
#define APP_VERSION_BUILD 6
```

Let us run make command from the build directory to build a new binary file for the OTA update, from the **amazon-freertos/build** directory,

```
build$ make
```

You should now have the latest firmware ready to be deployed via AWS IoT Device Management. We will now go through the OTA workflow to deploy the firmware update to your thing. Before that we need to upload the firmware to the S3 bucket we created before.

```
$ aws s3 cp aws_demos.bin s3://<BUCKET_NAME>/firmware_v_1_1.bin
upload: ./firmware.bin to s3://<BUCKET_NAME>/firmware_v_1_1.bin
```

## Deploying the update

### 1. Setup the OTA Job

We are now all set to deploy the update to the Kakematic device. Head to the AWS IoT Console and then select AWS IoT from the Services menu. Select **Manage** and then **Jobs** from the side menu and hit **Create a job**,

![Job create welcome](ws_create_job_welcome.png?raw=true)

Choose **Create OTA update job**, OTA jobs are used for Firmware updates. **Create custom job** option is used for sending commands or configuration to the devices.

![Job create welcome](ws_creat_ota_job.png?raw=true)

Select your thing from the list or search for your thing. You can find your thing name at the workshop/tools/thingName file if you have forgotten the name.

![Job create welcome](ws_select_thing_for_ota.png?raw=true)

Select your thing as shown below, hit Next

![Select thing](ws_thing_selected_for_ota.png?raw=true)

Select "Sign new firmware image for me",

Select "Create" for Code signing profile, and enter the information as shown below,

![Select thing](ws_code_signing_profile.png?raw=true)

Fill in the required fields as shown below,

![Select thing](ws_ota_info_provided.png?raw=true)

1. The firmware image in S3 - Location where you uploaded the new firmware
2. `/var` in the Pathname of the firmware image on the device - This does not apply to this workshop as we do not have a filesystem in flash, but the field is mandatory, let us just put in a string.
3. IAM Role for an OTA Job - We have created an IAM Role for this workshop named **ota-update-reinvent-role**, let us just select that.

The policy attached to the IAM Role **ota-update-reinvent-role** looks like the below, it provides access to the AWS Services that are required,

1. S3 - For access to the firmware and storung the signed images
2. ACM (Amazon Certificate Manager) for signing the firmware, remember we put our Code siging certificate there
3. AWS IoT core, IAM and Freertos for the various operations required to be done during the Job creation step.

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:*",
                "acm:ImportCertificate",
                "acm:ListCertificates",
                "iot:*",
                "iam:ListRoles",
                "freertos:ListHardwarePlatforms",
                "freertos:DescribeHardwarePlatform"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:PutObject"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "signer:*"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "iam:PassRole",
            "Resource": "arn:aws:iam::xxxxxxxxxxx:role/ota-update-reinvent-role"
        }
    ]
}
```

Finally, let us fill in the fields for creating an OTA update job,

![Create OTA Job](ws_final_ota_step.png?raw=true)

Before you hit the Create button make sure you have the Kakematic device already connected to the network and running the Production formware we flashed at the Factory. Even if it is not connected the Jobs are queued on the Device in the cloud, the next time it connects and subscribes to the Job topics it will receive the queued job. Hence, the device will never **_lose a Job ;-)_**

### 2. OTA firmware update

We are currently running the Production firmware flashed at the factory. The firmware has already subscribed to MQTT topics to listen to new Jobs being targeted at our Thing. So, if everything was setup correctly, we should see a new Job PUBLISH being received and the OTA Agent doing the firmware download.

Let us monitor the firmware being updated on the device. Once the update completes, the downloaded OTA is verified and is successful, then it takes effect.

Now our Green LED Blinks instead of the RED LED on our Kakematic device when the baking is completed.
Hurray!!!

**How does it work?**

Please look at the below code fro aws_iot_ota_update_demo.c from the **amazon-freertos/demos/ota** directory,

```
/* Connect to the broker. */
if (IotMqtt_Connect(&(xConnection.xNetworkInfo),
    &xConnectInfo,
    otaDemoCONN_TIMEOUT_MS, &(xConnection.xMqttConnection)) == IOT_MQTT_SUCCESS)
    {
        configPRINTF(("Connected to broker.\r\n"));
        OTA_AgentInit(xConnection.xMqttConnection, (const uint8_t *)(clientcredentialIOT_THING_NAME), 
                      App_OTACompleteCallback, (TickType_t)~0);
                      
        xTaskCreate(pBlinkOnCakeReady,
                    "RED Blinker Task",
                    democonfigDEMO_STACKSIZE,
                    (void *)NULL,
                    democonfigDEMO_PRIORITY,
                    &xHandle);
                    
        while ((eState = OTA_GetAgentState()) != eOTA_AgentState_NotReady)
        {
            /* Wait forever for OTA traffic but allow other tasks to run and output statistics only once per second. */
            vTaskDelay(myappONE_SECOND_DELAY_IN_TICKS);
            configPRINTF(("State: %s  Received: %u   Queued: %u   Processed: %u   Dropped: %u\r\n", 
                           pcStateStr[eState],
                           OTA_GetPacketsReceived(), OTA_GetPacketsQueued(), 
                           OTA_GetPacketsProcessed(), OTA_GetPacketsDropped()));
        }

    IotMqtt_Disconnect(xConnection.xMqttConnection, false);
}
else
{
    configPRINTF(("ERROR:  MQTT_AGENT_Connect() Failed.\r\n"));
}
         
```
## The OTA(Over-the-air) Agent explained

**OTA_AgentInit** function is the initialisation function of the OTA Agent which is responsible for managing the complexity of the OTA Job on behalf of the Application. On startup, it queries for Jobs being Queued for the Device on the cloud, Subscribes to MQTT topics, retreieves the firmware image via MQTT and also updates the Job progress and final status to the Cloud. 

```
  OTA_AgentInit(xConnection.xMqttConnection, (const uint8_t *)(clientcredentialIOT_THING_NAME), 
                App_OTACompleteCallback, (TickType_t)~0)
```

The OTA Agent also provides callbacks to the Application via the **App_OTACompleteCallback** (in the above example), this is a user defined function which will receive the following events,

```
typedef enum
{
    eOTA_JobEvent_Activate = 0,  /*!< OTA receive is authenticated and ready to activate. */
    eOTA_JobEvent_Fail = 1,      /*!< OTA receive failed. Unable to use this update. */
    eOTA_JobEvent_StartTest = 2, /*!< OTA job is now in self test, perform user tests. */
    eOTA_LastJobEvent = eOTA_JobEvent_StartTest
} OTA_JobEvent_t;
```
The Application can decide how it wants to handle these Events. Please go through the **App_OTACompleteCallback** to get an understanding how these events are handled in this workshop. 

For more information, please refer to the documentation here:

https://docs.aws.amazon.com/freertos/latest/userguide/freertos-ota-dev.html
https://docs.aws.amazon.com/freertos/latest/userguide/ota-agent-library.html




| [Previous section](./03_FIRMWARE_AND_PARTITION_BUILD.md) | [Main](../README.md) | [Next section](../README.md) |
