#Juego Snake
$(document).ready () ->
	canvas = $("#canvas")[0]
	ctx = canvas.getContext "2d"
	w = $("#canvas").width()
	snake_array = []
	food = {}
	score = 0
	game_loop = 0
	d = "right"
	h = $("#canvas").height()

	#Save the cell width in a variable for easy control
	cw = 10

	create_snake = () ->
		snake_array = ({x: i, y: 0} for i in [4..0] by -1)
	create_food = () ->
		x: Math.round(Math.random()*(w-cw)/cw), y: Math.round(Math.random()*(h-cw)/cw)
	paint = () ->
		#Paint the canvas
		ctx.fillStyle = "#CCC";
		ctx.fillRect(0, 0, w, h);
		ctx.strokeRect(0, 0, w, h);
		#Snake movement: pull out the tail and place it in the head
		nx = snake_array[0].x;
		ny = snake_array[0].y;	
		switch d
			when "right" then nx++
			when "left" then nx--
			when "up" then ny--
			when "down" then ny++
		#If the snake hits the wall restart the game
		return init() if nx == -1 || nx == w/cw || ny == -1 || ny == h/cw || check_collision(nx, ny, snake_array)
		#When the snake eats the food
		if nx == food.x and ny == food.y
			tail = x: nx, y:ny
			score++
			food = create_food()
		else
			tail = snake_array.pop()
			tail.x = nx
			tail.y = ny
		snake_array.unshift tail
		#Paint the snake
		for i in [0...snake_array.length]
			c = snake_array[i]
			paint_cell c.x,c.y
		#Paint the food
		paint_cell food.x, food.y
		#Paint score
		ctx.fillText "Score: #{score}", 5, h-5
	paint_cell = (x,y) ->
		ctx.fillStyle = "blue"
		ctx.fillRect x*cw, y*cw, cw, cw
		ctx.strokeStyle = "white"
		ctx.strokeRect x*cw, y*cw, cw, cw
	check_collision = (x,y,array) ->
		for i in [0...array.length]
			return true if array[i].x is x and array[i].y is y
		return false
	init = () ->
		d = "right"
		create_snake()
		food = create_food()
		#Display score
		score = 0
		#Move the snake using a timer which will trigger the paint function every 60ms
		clearInterval(game_loop) if game_loop?
		game_loop = setInterval(paint,60)
	init()		

	$(document).keydown (e) ->
		key = e.which;
		switch key
			when 65 then d = "left" if d != "right"
			when 87 then d = "up" if d != "down"
			when 68 then d = "right" if d != "left"
			when 83 then d = "down" if d != "up"
		#We will add another clause to prevent reverse gear
		###
		if key == "65" && d != "right" then d = "left"
		else if key == "87" && d != "down" then d = "up"
		else if key == "68" && d != "left" then d = "right"
		else if key == "83" && d != "up" then d = "down"
		###