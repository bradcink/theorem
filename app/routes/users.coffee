passport = require "passport"
users = require "../controllers/users"

module.exports = (app) ->
  # auth
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
  ), users.signin

  # callback
  app.get "/auth/venmo/callback", passport.authenticate("venmo",
    failureRedirect: "/"
  ), users.authCallback

  # payment
  app.post "/auth/venmo/payment", (req, res) ->
    # using the request library with a callback
    request.post "https://api.venmo.com/v1/payments",
      form: req.body
    , (e, r, venmo_receipt) ->
      # parsing the returned JSON string into an object
      venmo_receipt = JSON.parse(venmo_receipt)
      res.render "success",
        venmo_receipt: venmo_receipt
      return
    return