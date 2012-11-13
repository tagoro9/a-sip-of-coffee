#Simple node chat using web sockets
PORT = 8080
express = require 'express'
socket = require 'socket.io'

app = express()

server = require('http').createServer app
io = socket.listen server

#App configuration
app.configure ->
	app.use require('connect-assets')()
	app.use express.static("#{__dirname}/public")
	app.set 'views', "#{__dirname}/views"
	app.set 'view engine', 'ejs'

#Serve the chat page
app.get '/', (req,res) ->
	res.render 'index'

#Clients array
clients = []

#Configure events on the chat
io.sockets.on 'connection', (client) ->
	console.log "Client connected..."
	client.on 'message', (data) ->
		console.log data
		client.broadcast.emit 'message',data
	client.on 'join', (name) ->
		console.log "#{name} logged in."
		client.emit 'connected-users', clients
		client.set 'name', name
		clients.push(name)
		client.broadcast.emit 'joined', name
	client.on 'disconnect', () ->
		client.get 'name', (err,name) ->
			console.log "#{name} disconnected"
			client.broadcast.emit 'logout', name
			clients.splice clients.indexOf(name),1


server.listen PORT
console.log "Server listening on port #{PORT}"

