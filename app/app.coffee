express = require "express"

coreRoutes = require "./routes/core"


# Configuration
app = express.createServer()
app.configure(() ->
  app.set('views', __dirname + '/views')
  app.set('view engine', 'jade')
  app.set('view options', { ayout: false})
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use express.static(__dirname + '/public')
  app.use app.router
)

app.configure('development', () ->
  app.use express.errorHandler(
    dumpExceptions: true
    showStack: true
  )
)

app.configure('production', () ->
  app.use express.errorHandler()
)


# Routes
coreRoutes(app)


# Server
app.listen(3000, () ->
  console.log "Express server listening on port %d in %s mode",
    app.address().port, app.settings.env)
)

module.exports = app
