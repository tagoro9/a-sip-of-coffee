$(document).ready () ->

	$('.start-show').click () ->
		#Get url to load
		url = $(this).data 'url'
		window.location.href = "/presentation/#{url}/"

	#Carousel elements
	carouselElems = parseInt($('.carousel-elem').length)
	maxLenght = -1040 * (carouselElems - 1)
###
	$('.carousel-controls > a').click (event) ->
		event.preventDefault()
		posX = $('#carousel-container').position().left
		switch $(this).data 'dir'
			when "back" then dir = '+'
			when "forward" then dir = '-'
		$('#carousel-container').transition x: "#{dir}=1040", 600 if (posX != 0 && dir != '-') || (posX != maxLenght && dir != '+')
		#alert $('#carousel-container').position().left
###
