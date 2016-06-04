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
#   /version
swig = require('swig')
querystring = require('querystring')
fs = require('fs')
path = require('path')
TEMPLATE_DIR = "./scripts/template/"

fileExists = (filePath) ->
  try
    fs.statSync(filePath).isFile()
  catch err
    false


module.exports = (robot) ->
  robot.router.get "/", (req, res) ->
    res.type "html"
    res.end swig.renderFile("#{TEMPLATE_DIR}/index.html", {})

  robot.router.get "/yasuna/view", (req, res) ->
    query = querystring.parse req._parsedUrl.query
    tmp = path.join '/tmp', path.basename(query.id)
    if fileExists(tmp)
      fs.readFile tmp, (err, data) ->
        res.writeHead(200, {'Content-Type': 'image/png'})
        res.end(data)
    else
      res.status(404).send('Not Found')
