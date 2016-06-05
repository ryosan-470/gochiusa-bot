# Description:
#   A simple interaction with the build in HTTP Daemon
#
# Commands:
#   None
#
# Configuration:
#   None
#
# URLS:
#   /     TOP PAGE
#   /api/yasuna  create yasuna
swig = require('swig')
TEMPLATE_DIR = "./scripts/template/"
yasuna = require("./yasuna")

fileExists = (filePath) ->
  try
    fs.statSync(filePath).isFile()
  catch err
    false


module.exports = (robot) ->
  robot.router.get "/", (req, res) ->
    res.type "html"
    res.end swig.renderFile("#{TEMPLATE_DIR}/index.html", {})

  robot.router.get "/api/yasuna", (req, res) ->
    yasuna.init(req, res)
