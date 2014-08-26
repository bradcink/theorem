mongoose = require "mongoose"


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
