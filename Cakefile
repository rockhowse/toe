{exec} = require 'child_process'

handler = (error, stdout, stderr, callback = ->) ->
  throw error if error
  
  process.stdout.write stdout
  
  callback()

task 'clean', 'clean out npm dependencies', (options) ->
  exec 'rm -Rf node_modules'

task 'npm', 'update npm package and install dependencies', (options) ->
  exec 'courier', (error, stdout, stderr) ->
    handler error, stdout, stderr, ->
      exec 'npm i', handler