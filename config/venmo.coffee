VenmoStrategy = require("passport-venmo").Strategy

User = require('../app/models/user')


###
To get the clientID and the clientSecret you must log in to Venmo
go to the developer tab on the user page and create a new app.
You will be prompted to specify your callback url, however, they
call it your Web Redirect URL
###
CLIENT_ID = "1911"
CLIENT_SECRET = "MP8FPA4TXQB7u6Bd9Q3d8Pnw7dpVBcnU"
CALLBACK_URL = "http://localhost:3000/auth/venmo/callback"


###
Use the VenmoStrategy
Strategies in Passport require a 'verify' function, which
is the anonymous function we define as the second parameter
of passport.use

The 'verify' function accepts an accessToken, refreshToken,
a 'venmo' object containing an authorized user's information
and invoke callback function with the user object.
###
strategy = new VenmoStrategy(
  clientID: CLIENT_ID
  clientSecret: CLIENT_SECRET
  callbackURL: CALLBACK_URL
, (accessToken, refreshToken, venmo, done) ->
  User.findOne
    "venmo.id": venmo.id
  , (err, user) ->
    return done(err)  if err

    # Check if the user has been already been created, if not
    # create a new instance of the User model.
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

module.exports = strategy
