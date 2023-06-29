# Basic Data Server Monitor (Server)

Can be used with the [Basic Data Server Monitor (Client)](http://github.com/firminsurgithub/bdsm-client) to monitor your server's CPU, RAM and Disk usage.

## Installation (Linux-systemD) <- Recommanded for most users
Install and setup BDSM-Server by running that command: 
```
curl 'https://raw.githubusercontent.com/firminsurgithub/bdsm-server/master/install-linux.sh' | sh
```

If you want to uninstall BDSM-Server, run that command:
```
curl 'https://raw.githubusercontent.com/firminsurgithub/bdsm-server/master/uninstall-linux.sh' | sh
```

The preferences are stored in `/usr/share/bdsm-server/.env`

## Installation (nodejs) 

Create .env file in root directory and add the following variables:

```bash
SERVER_NAME="My Awesome Server"
PORT=3040
PASSWORD="myawesomepassword"
```

(You can change the server name, port and password to whatever you want)


Then, run the following command:

```bash
# Install dependencies
npm install

# Start the server in a detached screen to keep it running even if you close the terminal
screen -S bdsm-server # On linux

# Start the server
npm start
```

(To exit the detached screen, press `Ctrl + A` and then `D`)

## Special Thanks

- [**@0x454d505459**](http://github.com/0x454d505459) - Contributor