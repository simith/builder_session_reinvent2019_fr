## 1. Setup the Cloud environment by logging in to the AWS Console

Using the provided username,password and AWS Console URL,login to the AWS Console. 
 ![Console](ws_console_login.png?raw=true)





After logging in succesfully, select Cloud9 from the Services menu as shown below,


![Select Cloud9](ws_select_cloud9.png?raw=true)


You should be able to see an environment configured for you, something like the below, (If you do not see one, click on the menu bar on the left and choose "Your environments")

 ![Cloud9 Console](ws_cloud_9_console.png?raw=true) 



Finally, click on the Open IDE button to go straight into your Cloud9 environment,

![](ws_cloud9_interface.png?raw=true)


The above Cloud9 interface has a Text editor at the top and a terminal at the bottom!


## 2. Downloading the repository for the workshop

Execute the following command to setup the environment variables, 

``` 
$source ~/.bash_profile
```

Please note, from the **environment** directory, 

Git repository: https://github.com/simith/builder_session_reinvent2019_fr

```
$git clone https://github.com/simith/builder_session_reinvent2019_fr
```

 ![](ws_git_clone.png?raw=true)

The **builder_session_reinvent2019_fr** repository has 2 directories,

**workshop/amazon-freertos**: Amazon FreeRTOS source code

**workshop/tools**: Tools to automate the Thing creation and a few other things (More later)





