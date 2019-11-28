# Workshop Setup

## 1. Setup the Cloud environment by logging in to the AWS Console

Using the provided username, password and AWS Console URL, login to the AWS Console.

 ![Console](ws_console_login.png?raw=true)
 

After logging in successfully, select the correct region "Oregon" (us-west-2) from the top as shown in below.

 ![Select Region](ws_region_select.png?raw=true)
 

Then select Cloud9 from the Services menu as shown below,

 ![Select Cloud9](ws_select_cloud9.png?raw=true)


You should be able to see an environment configured for you, something like the below, (If you do not see one, click on the menu bar on the left and choose "Your environments")

 ![Cloud9 Console](ws_cloud_9_console.png?raw=true)


Finally, click on the Open IDE button to go straight into your Cloud9 environment,

![Open Cloud9](ws_cloud9_interface.png?raw=true)


The above Cloud9 interface has a Text editor at the top and a terminal at the bottom!

## 2. Downloading the repository for the workshop

Git repository: https://github.com/simith/builder_session_reinvent2019_fr

You can clone the git repository by running the following command.

```
$git clone https://github.com/simith/builder_session_reinvent2019_fr
```

You should see an output as follows.

```
Cloning into 'builder_session_reinvent2019_fr'...
remote: Enumerating objects: 54, done.
remote: Counting objects: 100% (54/54), done.
remote: Compressing objects: 100% (54/54), done.
remote: Total 8293 (delta 28), reused 0 (delta 0), pack-reused 8239
Receiving objects: 100% (8293/8293), 30.41 MiB | 22.52 MiB/s, done.
Resolving deltas: 100% (2621/2621), done.
```

The repository has 2 directories,

**workshop/amazon-freertos**: Amazon FreeRTOS source code

**workshop/tools**: Tools to automate the Thing creation and a few other things (More later)

### Setting up the workshop root directory

We need to setup the WORKSHOP_ROOT_DIR environment variable, which is referenced by the scripts used in this workshop, you can set the variable by following the below,

```
cd builder_session_reinvent2019_fr
$WORKSHOP_ROOT_DIR=$PWD
```


 | [Previous section](../READ.md) | [Main](../README.md) | [Next section](./02_AWS_IOT_SETUP.md) |
