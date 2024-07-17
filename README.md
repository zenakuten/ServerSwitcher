# ServerSwitcher

Use this mutator when moving servers in UT2004.  

ServerSwitcher will move players from one server to another.  It will also list any players on the new server as if they were playing on the old server in the server browser.  To use, run ServerSwitcher as a mutator on the old server and configure it point to the new server.

Example UT2004.ini

```
[ServerSwitcher.MutServerSwitcher]
SwitchTime=5.0
NewServer=127.0.0.1
NewServerPort=7777
PingTime=20
```

## Options

`SwitchTime` - How long to wait before switching players to the new server.  Default is 5 seconds

`NewServer` - IP address of the new server

`NewServerPort` - Game port of the new server

`PingTime` - How often to query the new server to get the current list of players.