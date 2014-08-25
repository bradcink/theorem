
###
Module dependencies.
###
crypto = require("crypto")
mongoose = require("mongoose")
mongoose.connect "mongodb://localhost/venmo-example"
db = mongoose.connection
db.on "error", console.error.bind(console, "connection error:")
db.once "open", callback = ->
  console.log "Mongoose connection is open"
  return


###
User Schema
###
Schema = mongoose.Schema
UserSchema = new Schema(
  name:
    type: String
    required: true
  email: String
  username:
    type: String
    unique: true
  balance: String
  provider: String
  salt: String
  venmo: {}
  access_token: String
  refresh_token: String
)

User = mongoose.model("User", UserSchema)
module.exports = User
