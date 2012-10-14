#Cell width
cw = 10

class Food

	constructor: (w,h) -> #Get random coordintates for the food
		@x = Math.round(Math.random()*(w-cw)/cw)
		@y = Math.round(Math.random()*(h-cw)/cw)

class Snake

	constructor: (length = 4) ->
		@array = ({x: i, y: 0} for i in [length..0] by -1)

	head: () ->
		return @array[0]

class Game

	constructor: () ->
		$(document).ready () =>
			canvas = $('#canvas')[0]
			@canvas = canvas.getContext "2d"
			@w = $('#canvas').width() #Canvas width
			@h = $('#canvas').height() #Canvas height
			#Keyboard controls (w,s,a,d)
			$(document).keydown (e) =>
				switch e.which
					when 65 then @d = "left" if @d != "right" 
					when 87 then @d = "up" if @d != "down"
					when 68 then @d = "right" if @d != "left"
					when 83 then @d = "down" if @d != "up"
			@init()		


	init: () ->
		@d = "right" #Initial direction
		@snake = new Snake()
		@food = new Food(@w,@h)
		@score = 0
		clearInterval @game_loop if @game_loop?
		@game_loop = setInterval (()=> @paint()), 60 #This determines the snake speed

	check_collision: (x,y) ->
		for i in [0...@snake.array.length]
			return true if @snake.array[i].x is x and @snake.array[i].y is y
		return false

	paint_cell: (x,y, color = "#00F") ->
		@canvas.fillStyle = color
		@canvas.fillRect x*cw, y*cw, cw, cw
		@canvas.strokeStyle = "#FFF"
		@canvas.strokeRect x*cw, y*cw, cw, cw

	next_move: () ->
		#Get the head pos
		nx = @snake.head().x
		ny = @snake.head().y
		switch @d #Move depending on direction
			when "right" then nx++
			when "left" then nx--
			when "up" then ny--
			when "down" then ny++	
		#If the snake hits the wall
		switch nx
			when -1 then nx = @w/cw-1
			when @w/cw then nx = 0
		switch ny
			when -1 then ny = @h/cw-1
			when @h/cw then ny = 0	
		x: nx, y: ny				

	play: (move) ->
		#If the snake hits itself restart game
		return false if @check_collision move.x,move.y		
		#When the snake eats the food
		if move.x == @food.x and move.y == @food.y
			tail = x: move.x, y:move.y
			@score++
			@food = new Food(@w,@h)
		else
			tail = @snake.array.pop()
			tail.x = move.x
			tail.y = move.y
		@snake.array.unshift tail
		return true	

	paint: () ->
		#Paint the canvas
		@canvas.fillStyle = "#CCC";
		@canvas.fillRect(0, 0, @w, @h);
		@canvas.strokeRect(0, 0, @w, @h);
		#Get snake's next move
		move = @next_move()
		return @init() unless @play move
		#Paint the snake
		for i in [0...@snake.array.length]
			@paint_cell @snake.array[i].x,@snake.array[i].y
		#Paint the food
		@paint_cell @food.x, @food.y
		#Paint score
		@canvas.fillText "Score: #{@score}", 5, @h-5		

game = new Game()