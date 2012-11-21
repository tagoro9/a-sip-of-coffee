#Pages controller
names = ['coffee', 'node']

#Index page with information about presentations
app.get '/', (req,res) ->
    res.render 'index'

app.get '/material', (req,res)->
	res.render 'material'

app.get '/about', (req,res)->
	res.render 'about'

#Presentations page
app.get '/presentation/:name', (req,res) ->
	name = req.param('name')
	if names.indexOf(name) isnt -1
		res.render "presentations/#{name}"	
	else
		res.send 404