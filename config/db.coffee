crypto = require "crypto"
mongoose = require "mongoose"

env = require "./environment"


###
Connection socket location.
Later we will change this to depend on the environment in env.
###
MONGO_SERVER = "mongodb://localhost/venmo-example"


###
Database object
###
db = { }

db.connect = () ->
  mongoose.connect MONGO_SERVER
  mongo = mongoose.connection
  mongo.on "error", console.error.bind(console, "connection error:")
  mongo.once "open", callback = ->
    console.log "|- Mongoose connection is open."

# Export database object
module.exports = db
