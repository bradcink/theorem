###
Module dependencies.
###

# var Venmo = require('venmo');
# var venmo = new Venmo(client_id, client_secret);
User = require("../models/user.coffee")["User"]
exports.index = (req, res) ->
  res.render "index",
    user: (if req.user then JSON.stringify(req.user) else "null")

  return


###
Auth callback
###
exports.authCallback = (req, res) ->
  res.render "payment",
    user: (if req.user then JSON.stringify(req.user) else "null")

  return


###
Show login form
###
exports.signin = (req, res) ->
  res.render "users/signin",
    title: "Signin"
    message: req.flash("error")

  return

exports.receipt = (req, res) ->
  console.log req.body
  res.render "success",
    user: (if req.user then JSON.stringify(req.user) else "null")

  return