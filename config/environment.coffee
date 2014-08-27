globule = require "globule"


# namespace
env = { }


# env
env.debug = "-debug" in process.argv
env.production = process.env.NODE_ENV is "production"


# ports
env.devPort = 3000
env.prodPort = process.env.PORT? or env.devPort
env.port = if env.production then env.prodPort else env.devPort


# paths
env.less_paths = globule.find "#{__dirname}/../client/modules/**/styles"
env.coffee_paths = globule.find "#{__dirname}/../client/**/"
env.paths = env.less_paths.concat env.coffee_paths


# export
module.exports = env
