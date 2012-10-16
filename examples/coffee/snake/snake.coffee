#Ancho de una celda del tablero
cw = 10

#Clase canvas. Este sera el "tablero" de juego
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

#Se declara un nuevo tablero
canvas = new Canvas()		

#Punto en el tablero de juego
class Point

	constructor: (@x ,@y) ->
	paint: (color = "#00F") ->
		canvas.paint_cell @x,@y,color

#Comida que hara que la serpiente vaya creciendo
class Food extends Point

	constructor: (w,h) -> #Obtener coordenadas aleatorias para la comida
		@x = Math.round(Math.random()*(w-cw)/cw)
		@y = Math.round(Math.random()*(h-cw)/cw)

#Una serpiente estará compuesta por un array de puntos
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
			$(document).keydown (e) => 	#controles de teclado (w,s,a,d)
				switch e.which
					when 65 then @d = "left" if @d != "right" 
					when 87 then @d = "up" if @d != "down"
					when 68 then @d = "right" if @d != "left"
					when 83 then @d = "down" if @d != "up"
			@init()		


	init: () ->
		@d = "right" #Direccion inicial
		@snake = new Snake()
		@food = new Food(canvas.w,canvas.h)
		@score = 0
		clearInterval @game_loop if @game_loop?
		@game_loop = setInterval (()=> @paint()), 60 #Esto determina la velocidad de la serpiente

	#Comprobar si algun punto de la serpiente esta en las coordenadas x,y
	check_collision: (x,y) ->
		for i in [0...@snake.array.length]
			return true if @snake.array[i].x is x and @snake.array[i].y is y
		return false

	#Obtener la siguiente posicion de la serpiente. Se mira la posicion de la cabeza
	# y en funcion de la direccion o si esta en un borde se determina la siguiente posicion
	next_move: () ->
		#Get the head pos
		nx = @snake.head().x
		ny = @snake.head().y
		switch @d #Mover dependiendo de la direccion
			when "right" then nx++
			when "left" then nx--
			when "up" then ny--
			when "down" then ny++	
		#Si la serpiente choca contra una pared
		switch nx
			when -1 then nx = canvas.w/cw-1
			when canvas.w/cw then nx = 0
		switch ny
			when -1 then ny = canvas.h/cw-1
			when canvas.h/cw then ny = 0	
		x: nx, y: ny				

	#Mover la serpiente. Se extrae la cola de la misma y se pone a la cabeza en las coordenadas pasadas por parametro
	play: (move) ->
		#Empezar otra vez si la serpiente choca contra si misma
		return false if @check_collision move.x,move.y		
		#Si la serpiente se come la comida.
		if move.x == @food.x and move.y == @food.y
			tail = new Point move.x, move.y
			@score++
			@food = new Food(canvas.w,canvas.h) #Crear nueva comida
		else
			tail = @snake.array.pop()
			tail.x = move.x
			tail.y = move.y
		@snake.array.unshift tail
		return true	

	paint: () ->
		canvas.reset() #Resetear el tablero canvas
		#Obtener el siguiente movimiento de la serpiente
		return @init() unless @play @next_move()
		#Pintar la serpiente
		@snake.paint()
		#Pintar la comida
		@food.paint()
		#Pintar la puntuacion
		canvas.canvas.fillText "Score: #{@score}", 5, canvas.h-5

game = new Game()