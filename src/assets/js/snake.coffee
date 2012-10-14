#Cell width
cw = 10

class Canvas

	constructor: (id = "canvas") ->
		$(document).ready () =>
			canvas = $("##{id}")[0]
			@canvas = canvas.getContext "2d"
			@w = $('#canvas').width() #Canvas width
			@h = $('#canvas').height() #Canvas height
			@reset()	

	reset: () ->
		@canvas.fillStyle = "#CCC";
		@canvas.fillRect(0, 0, @w, @h);
		@canvas.strokeRect(0, 0, @w, @h);		

	paint_cell: (x,y, color) ->
		@canvas.fillStyle = color
		@canvas.fillRect x*cw, y*cw, cw, cw
		@canvas.strokeStyle = "#FFF"
		@canvas.strokeRect x*cw, y*cw, cw, cw

canvas = new Canvas()		

class Point

	constructor: (@x ,@y) ->
	paint: (color = "#00F") ->
		canvas.paint_cell @x,@y,color

class Food extends Point

	constructor: (w,h) -> #Get random coordintates for the food
		@x = Math.round(Math.random()*(w-cw)/cw)
		@y = Math.round(Math.random()*(h-cw)/cw)


class Snake

	constructor: (length = 4) ->
		@array = (new Point(i,0) for i in [length..0] by -1)

	head: () ->
		return @array[0]

	paint: () ->
		point.paint() for point in @array

class Game

	constructor: () ->
		$(document).ready () =>
			$(document).keydown (e) => 	#Keyboard controls (w,s,a,d)
				switch e.which
					when 65 then @d = "left" if @d != "right" 
					when 87 then @d = "up" if @d != "down"
					when 68 then @d = "right" if @d != "left"
					when 83 then @d = "down" if @d != "up"
			@init()		


	init: () ->
		@d = "right" #Initial direction
		@snake = new Snake()
		@food = new Food(canvas.w,canvas.h)
		@score = 0
		clearInterval @game_loop if @game_loop?
		@game_loop = setInterval (()=> @paint()), 60 #This determines the snake speed

	check_collision: (x,y) ->
		for i in [0...@snake.array.length]
			return true if @snake.array[i].x is x and @snake.array[i].y is y
		return false

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
			when -1 then nx = canvas.w/cw-1
			when canvas.w/cw then nx = 0
		switch ny
			when -1 then ny = canvas.h/cw-1
			when canvas.h/cw then ny = 0	
		x: nx, y: ny				

	play: (move) ->
		#If the snake hits itself restart game
		return false if @check_collision move.x,move.y		
		#When the snake eats the food
		if move.x == @food.x and move.y == @food.y
			tail = new Point move.x, move.y
			@score++
			@food = new Food(canvas.w,canvas.h)
		else
			tail = @snake.array.pop()
			tail.x = move.x
			tail.y = move.y
		@snake.array.unshift tail
		return true	

	paint: () ->
		canvas.reset() #Reset canvas
		#Get snake's next move
		return @init() unless @play @next_move()
		@snake.paint()
		#Paint the food
		@food.paint()
		#Paint score
		canvas.canvas.fillText "Score: #{@score}", 5, canvas.h-5

game = new Game()