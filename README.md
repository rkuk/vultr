This repo consists of pure shell scripts used to automate the creation and destroy of servers with custom services on [vultr.com](http://vultr.com) via vultr API. They can be executed on any Linux devices(including the virtual machine themselves created on vultr.com) with different CPU architectures, such as x86 and arm. 

The main commands used frequently are `create` and `destroy`.

### Create a server with custom services

  You can use `create` to create a server instance on vultr.com, giving some configurations(such as server location, OS, startup script) to the server at the same time.

  1. Prerequisites   
  `create` requires you to export `VULTR_API_KEY` before using it, you can get it from [your vultr account](https://my.vultr.com/settings/#settingsapi), and don't forget to add your IP to the whitelist to allow scripts to use vultr API.  
  `create` also denpends on the `jq` package, you should install `jq` in advance. On ubuntu you can do it with `apt install jq`.

  2. The usage of `create` is: `create [options] [startupscript]`  
  `options` includs:  
  - `-c` : location of the server, default to "Los Angeles".
  - `-o` : OS name, default to "ubuntu 18.04".
  - `-s` : snapshot description, this option is ignored when startupscript is given.
  - `-l` : server label, which is shown on vultr.com control panel.
  - `-t` : server lifetime(in hour), default to 1 hour. server created will be destroied automatically before its lifetime to avoid further charging.
  - `-u` : a path used by startup script to show service configurations via http, a random path will be used when not specified.

  `startupscript` can be a shell script file or script codes:  
  - script file: the file should be put in `./startup` directory and its name should be `setup_XXX.sh`, then you can use the file as startup script by giving `XXX.sh` or `XXX` here.
  - script codes:  you can input startup script codes on cli directly, but remember to single quote them in case of translation by bash.

  3. Notice  
  When giving startupscript to `create`, it will automatically create a startup script on vultr.com before server creation and remove it from vultr.com before server destroy.  
  Moreover, when executing `create`, all environment variables whose name starts with `VULTR` will be prepend to the top of startup script codes, so that you can make use of these `VULTR` variables in your custom startup script to configure the services. The value of option `-u` will also be given to a variable named `VULTR_INFO_URL`.
