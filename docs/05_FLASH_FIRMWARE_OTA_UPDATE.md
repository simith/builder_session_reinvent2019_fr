
## OTA Update 

### Making code changes for to fix the Bug

We now need to make some code changes to get the GREEN light flashing instead of the RED light and build the firmware and deploy it to the Cakematic device. The changes need to be done in the **ota** directory of **demos** in the file **aws_iot_ota_demo.c**, 

The path to the file within amazon-freertos will be as shown below,

```
amazon-freertos/demos/ota
```

![OTA Red to Green](ws_ota_red_to_green.png?raw=true)


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

We need to modify the line which sets the xGpioPin variable from GPIO_RED to GPIO_GREEN. Alternatively, if this was part of the configuration on what LED needs to blink on cake ready, this information could have been updated via an OTA Custom job in the NVS storage partition which we are using for storing 


