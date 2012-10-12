#Pages controller
names = ['coffee']

#Index page with information about presentations
app.get '/', (req,res) ->
    res.render 'index'

#Presentations page
app.get '/presentation/:name', (req,res) ->
	name = req.param('name')
	if names.indexOf(name) isnt -1
		res.render "presentations/presentation"	
	else
		res.send 404