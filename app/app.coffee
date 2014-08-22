
###
Module dependencies.
###
passport = require("passport")
VenmoStrategy = require("passport-venmo").Strategy
request = require("request")
swig = require("swig")
users_controller = require("./controllers/users.coffee")
path = require("path")
# *************************************************************

# To get the clientID and the clientSecret you must log in to Venmo
# go to the developer tab on the user page and create a new app.
# You will be prompted to specify your callback url, however, they
# call it your Web Redirect URL
Venmo_Client_ID = "1911"
Venmo_Client_SECRET = "MP8FPA4TXQB7u6Bd9Q3d8Pnw7dpVBcnU"
Venmo_Callback_URL = "http://localhost:3000/auth/venmo/callback"

# Keep the Venmo_Callback_URL as is for the purposes of this example.

# *************************************************************

User = require('./models/user.coffee')["User"];

connect = require "connect-assets"
express = require "express"
MongoStore = require("connect-mongo")(express)

config = require "./config"
coreRoutes = require "./routes/core"


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
  app.use connect { paths: config.less_paths }
  app.use(passport.initialize());
  app.use(passport.session());
  app.use app.router
)

app.configure("development", () ->
  app.use express.errorHandler(
    dumpExceptions: true
    showStack: true
  )
)

passport.serializeUser (user, done) ->
  done null, user
  return

passport.deserializeUser (obj, done) ->
  done null, obj
  return


app.configure("production", () ->
  app.use express.errorHandler()
)

# Use the VenmoStrategy
# Strategies in Passport require a 'verify' function, which
# is the anonymous function we define as the second parameter
# of passport.use
# The 'verify' function accepts an accessToken, refreshToken,
# a 'venmo' object containing an authorized user's information
# and invoke callback function with the user object.
passport.use new VenmoStrategy(
  clientID: Venmo_Client_ID
  clientSecret: Venmo_Client_SECRET
  callbackURL: Venmo_Callback_URL
, (accessToken, refreshToken, venmo, done) ->
  User.findOne
    "venmo.id": venmo.id
  , (err, user) ->
    return done(err)  if err
    
    # checks if the user has been already been created, if not
    # we create a new instance of the User model
    unless user
      user = new User(
        name: venmo.displayName
        username: venmo.username
        email: venmo.email
        provider: "venmo"
        venmo: venmo._json
        balance: venmo.balance
        access_token: accessToken
        refresh_token: refreshToken
      )
      user.save (err) ->
        console.log err  if err
        done err, user

    else
      user.balance = venmo.balance
      user.access_token = accessToken
      user.save()
      user.venmo = venmo._json
      done err, user
    return

  return
)

# Routes
coreRoutes(app)

app.get "/auth/venmo", passport.authenticate("venmo",
  scope: [
    "make_payments"
    "access_feed"
    "access_profile"
    "access_email"
    "access_phone"
    "access_balance"
    "access_friends"
  ]
  failureRedirect: "/"
), users_controller.signin
app.get "/auth/venmo/callback", passport.authenticate("venmo",
  failureRedirect: "/"
), users_controller.authCallback
app.post "/auth/venmo/payment", (req, res) ->
  
  #using the request library with a callback
  request.post "https://api.venmo.com/v1/payments",
    form: req.body
  , (e, r, venmo_receipt) ->
    
    # parsing the returned JSON string into an object
    venmo_receipt = JSON.parse(venmo_receipt)
    res.render "success",
      venmo_receipt: venmo_receipt

    return

  return



# Server
app.listen(config.port, () ->
  console.log "Express server listening on port %d in %s mode",
    app.address().port, app.settings.env
)

module.exports = app
