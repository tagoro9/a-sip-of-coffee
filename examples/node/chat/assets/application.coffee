server = io.connect 'http://localhost:8080'
server.on 'connect', (data) ->
	name = prompt "Input your name"
	server.emit 'join', name
	$('#settings h3').html name
	$('#settings h4').html "online"
server.on 'message', (data) ->
	console.log data
	element = $('<div class="message">'+data+'</div>')
	$('#log').append(element)			
	$('#log').animate {scrollTop: $('#log').scrollTop()+50+element.outerHeight()}, 1000		

server.on 'logout', (name) ->
	$("#user-#{name}").remove()

server.on 'connected-users', (clients) ->
	for client in clients
		$('#connected-users').append "<li id=\"user-#{name}\">#{client}</li>" if $('#connected-users').find("#user-#{name}").length is 0

server.on 'joined', (name) ->
	console.log "connected #{name}"
	console.log $('#connected-users').find("#user-#{name}")
	$('#connected-users').append "<li id=\"user-#{name}\">#{name}</li>" if $('#connected-users').find("#user-#{name}").length is 0
$ ->
	#Clear textarea
	$('#send-message').val '' 
	#When a message is sent
	$('#chat_form').submit (e) ->
		e.preventDefault()
		send_message = $('#send-message')
		server.emit 'message', send_message.val()
		element = $('<div class="message message-to">'+send_message.val()+'</div>')
		$('#log').append(element)			
		$('#log').animate {scrollTop: $('#log').scrollTop()+50+element.outerHeight()}, 1000
		send_message.val ''
	#When enter is pressed
	$('#chat_form').on 'keydown', (key) ->
		if key.keyCode == 13
			$(this).submit()
			key.preventDefault()