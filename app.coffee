### node ###
{EventEmitter} = require 'events'

### npm ###
browserify = require 'browserify'
connect = require 'connect'
dnode = require 'dnode'

### config ###
argv = require('optimist').argv
config = port: argv.port or 1337

### connect ###
middleware = [
  connect.static __dirname + '/public'
  browserify mount: '/browserify.js', entry: __dirname + '/modules/entry.coffee', watch: {interval: 1000}
]
app = connect.apply connect, middleware

app.listen config.port
console.log "http://localhost:#{config.port}/"

### dnode ###
dnode((remote, connection) ->
  
  return
).listen app
console.log "dnode://localhost:#{config.port}/"