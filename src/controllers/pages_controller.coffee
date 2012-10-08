#Pages controller
app.get '/', (req,res) ->
        res.render 'index', layout: false
