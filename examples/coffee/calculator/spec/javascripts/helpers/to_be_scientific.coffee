#Helper que permite comprobar si la calculadora esta en modo cientifico
beforeEach ->
	@addMatchers
		toBeScientific: ->
			@actual.scientific is true