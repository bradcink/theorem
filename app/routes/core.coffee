core = require "../controllers/core"

module.exports = (app) ->
  # Root
  app.get "/", core.index

  # Fallback
  app.get "*", core.index
