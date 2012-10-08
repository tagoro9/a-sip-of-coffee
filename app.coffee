#Setup express.js
global.express = require 'express'
global.app = express()
require "#{__dirname}/src/configuration"

#Set up a routing for pages
require "#{__dirname}/src/controllers/pages_controller"

#Start server
app.listen(3000)
console.log "Express server listening on port %d in %s mode", 3000, app.settings.env

