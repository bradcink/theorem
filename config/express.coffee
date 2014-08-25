express = require "express"
connect = require "connect-assets"
MongoStore = require("connect-mongo")(express)
passport = require "passport"

env = require "./environment"
venmo = require "./venmo"


###
Passport configuration
###
passport.use venmo
passport.serializeUser (user, done) ->
  done null, user
passport.deserializeUser (obj, done) ->
  done null, obj


###
Express server configuration
###
app = express.createServer()
app.configure(() ->
  # Engines.
  app.set("views", __dirname + "/views")
  app.set("view engine", "jade")
  app.set("view options", {layout: false})
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use express.logger("short")

  # Static directories.
  app.use "/lib", express.static("#{env.root}/bower_components")
  app.use express.static("#{env.root}/public")
  app.use connect { paths: env.less_paths }

  # Session and state.
  app.use app.router
  app.use(passport.initialize());
  app.use(passport.session());
)

app.configure("development", () ->
  app.use express.errorHandler(
    dumpExceptions: true
    showStack: true
  )
)

module.exports = app
