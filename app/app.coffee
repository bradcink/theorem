app = require "../config/express"
coreRoutes = require "./routes/core"
env = require "../config/environment"
userRoutes = require "./routes/users"


# Routes
coreRoutes app
userRoutes app


# Server
app.listen(env.port, () ->
  console.log "Express server listening on port %d in %s mode",
    app.address().port, app.settings.env
)

module.exports = app
