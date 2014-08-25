User = require "../models/user"


module.exports =
  ###
  Logged in
  ###
  index: (req, res) ->
    res.render "index",
      user: (if req.user then JSON.stringify(req.user) else "null")


  ###
  Auth callback
  ###
  authCallback: (req, res) ->
    res.render "payment",
      user: (if req.user then JSON.stringify(req.user) else "null")


  ###
  Show login form
  ###
  signin: (req, res) ->
    res.render "users/signin",
      title: "Signin"
      message: req.flash("error")

  receipt: (req, res) ->
    console.log req.body
    res.render "success",
      user: (if req.user then JSON.stringify(req.user) else "null")
