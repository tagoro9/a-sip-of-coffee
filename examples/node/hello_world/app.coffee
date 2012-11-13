#Node.js Hello world
http = require 'http'
PORT = 8080

app = http.createServer (response,request) ->
	request.end "Hello world"

app.listen PORT
console.log "App listening on port #{PORT}"
