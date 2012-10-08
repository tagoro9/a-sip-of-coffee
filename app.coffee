#Setup express.js
global.express = require 'express'
global.app = express()
require "#{__dirname}/src/configuration"

#Set up a routing for pages
require "#{__dirname}/src/controllers/pages_controller"

#Start server
port = process.env.PORT || 5000
app.listen(port)
console.log "Express server listening on port %d in %s mode", port, app.settings.env

