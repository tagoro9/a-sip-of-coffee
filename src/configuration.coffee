#Configure express.js
app.configure ->
        app.use express.bodyParser()
        app.use express.methodOverride()
        app.use express.cookieParser()
        app.use express.session(secret: 'd19e19fd62a216ecf7d7b1de434ad')
        app.use app.router
        app.use require('connect-assets')(src : "#{__dirname}/assets")
        app.use express.static("#{__dirname}/../public")
        app.use express.favicon("#{__dirname}/../public/favicon.ico")
        app.use express.errorHandler(dumpExceptions: true, showStack: true)
        app.engine 'ejs', engine
        app.set 'views', "#{__dirname}/views"
        app.set 'view engine', 'ejs'
