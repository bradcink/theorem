globule = require "globule"


# namespace
config = { }


# env
config.debug = "-debug" in process.argv
config.production = process.env.NODE_ENV is "production"


# ports
config.devPort = 3000
config.prodPort = process.env.PORT? or config.devPort
config.port = if config.production then config.prodPort else config.devPort


# paths
config.root = "#{__dirname}/.."
config.less_paths = globule.find "#{__dirname}/../client/modules/**/styles"
config.coffee_paths = globule.find "#{__dirname}/../client/**/"
config.paths = config.less_paths.concat config.coffee_paths


# export
module.exports = config
