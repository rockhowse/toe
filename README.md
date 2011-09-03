     ______   ______     ______   
    /\__  _\ /\  __ \   /\  ___\  
    \/_/\ \/ \ \ \/\ \  \ \  __\  
       \ \_\  \ \_____\  \ \_____\
        \/_/   \/_____/   \/_____/
## Theory of Everything
### an MMORPG written in CoffeeScript on node.js and HTML5/CSS3/WebGL

[http://www.youtube.com/watch?v=TXNdH_BpHkI](http://www.youtube.com/watch?v=TXNdH_BpHkI)

# installation
clone the source

    git clone https://github.com/feisty/ToE.git

cd

    cd ToE

install dependencies

    npm i

the dependencies will be installed locally in ./node_modules

    ava:ToE pyrotechnick$ npm i
    traverse@0.3.9 ./node_modules/traverse 
    colors@0.5.0 ./node_modules/colors 
    redis@0.6.0 ./node_modules/redis 
    underscore@1.1.6 ./node_modules/underscore 
    coffee-script@1.1.1 ./node_modules/coffee-script 
    connect@1.4.5 ./node_modules/connect 
    ├── mime@1.2.2
    └── qs@0.1.0
    dnode@0.7.2 ./node_modules/dnode 
    ├── lazy@1.0.5
    ├── dnode-protocol@0.0.9
    └── socket.io@0.6.18
    browserify@0.5.2 ./node_modules/browserify 
    ├── es5-shim@1.0.0
    ├── hashish@0.0.3
    ├── source@0.0.3
    ├── findit@0.0.5
    └── seq@0.2.5

You must install node_redis master until @mranney publishes it.

    npm i https://github.com/mranney/node_redis/tarball/master

ToE expects a redis-server instance configured with ./redis.conf to be running at all times

    redis-server redis.conf

now the ToE server can be started

    coffee server.coffee

by default ToE listens on port 1337

navigate to `http://localhost:1337`

![toe module index](http://i.imgur.com/Sj6Rq.png)

you can bypass the modules index by navigating to `http://localhost:1337/#/toe`

![toe module index](http://i.imgur.com/IeuHu.png)

# building
voxels can be spawned, selected and deleted using the applicable tools

messages are exchanged via redis pub/sub facilities

    redis> monitor
    OK
    1308421742.048236 "monitor"
    1308421746.260409 "publish" "voxel" "{\"key\":\"15:0:15\",\"address\":{\"x\":15,\"y\":0,\"z\":15},\"position\":{\"x\":1550,\"y\":50,\"z\":1550}}"
    1308421746.260700 "sadd" "voxels" "15:0:15"
    1308421747.850753 "publish" "delete" "{\"key\":\"15:0:15\"}"
    1308421747.851821 "srem" "voxels" "15:0:15"

voxels are also stored in the set with the key of "voxels" so that upon joining, clients fetch can fetch all voxels

    redis> keys *
    1) "voxels"
    redis> smembers voxels
     1) "4:0:4"
     2) "5:0:5"
     3) "6:0:6"
     4) "7:0:7"
     5) "0:0:0"
     6) "8:0:8"
     7) "1:0:1"
     8) "9:0:9"
     9) "2:0:2"
    10) "3:0:3"

once clients have fetched all voxels, they subscribe to future updates for voxel spawning and deleting

``` coffee
### client ###
@remote.subscribe 'voxel', (channel, signal) =>
  voxel = new Voxel key: signal.key
  voxel.mesh.position.copy signal.position
  voxel.mesh.key = signal.key
  @voxels[signal.key] = voxel
  @scene.addObject voxel.mesh

@remote.subscribe 'delete', (channel, signal) =>
  voxel = @voxels[signal.key]
  delete @voxels[signal.key]
  @scene.removeObject voxel.mesh

### server ###
@publish = (channel, message) ->
  db.publish channel, JSON.stringify(message)

@subscribe = (channel, callback) ->  
  client = redis.createClient()
  
  client.subscribe channel
  
  client.on 'message', (message_channel, message) ->
    callback message_channel, JSON.parse(message)
```

this simple mechanism keeps all clients in sync and allows players to collaboratively modify the world with voxels