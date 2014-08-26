connect = require "connect-assets"
express = require "express"
MongoStore = require("connect-mongo")(express)
passport = require "passport"

coreRoutes = require "./routes/core"
db = require "../config/db"
env = require "../config/environment"
User = require "./models/user"
usersRoutes = require "./routes/users"
venmo = require "../config/venmo"


# Configuration
app = express.createServer()
app.configure(() ->
  app.set("views", __dirname + "/views")
  app.set("view engine", "jade")
  app.set("view options", {layout: false})
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use express.logger("short")
  app.use "/lib", express.static(__dirname + "/../bower_components")
  app.use express.static(__dirname + "/../public")
  app.use connect { paths: env.less_paths }
  app.use(passport.initialize());
  app.use(passport.session());
  app.use app.router
)

# Development
app.configure("development", () ->
  app.use express.errorHandler(
    dumpExceptions: true
    showStack: true
  )
)

# Production
app.configure("production", () ->
  app.use express.errorHandler()
)


# Database
db.connect()


# Authentication
venmo passport


# Routing
usersRoutes app
coreRoutes app


# Server
app.listen(env.port, () ->
  console.log "|- Express server listening on port %d in %s mode.",
    app.address().port, app.settings.env
)

module.exports = app
