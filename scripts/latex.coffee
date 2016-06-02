# Description:
#   $$で囲まれたLaTeX形式の数式を返します
# Dependencies:
#   "hubot-slack-attachment"
#
# Commands:
#    $LaTeXCode$ => LaTeX picture
module.exports = (robot) ->
  MyUtil = require("./myutil")
  util = new MyUtil(robot)

  robot.hear /\$.+?\$/, (msg) ->
    expr = encodeURIComponent(msg.match[0].replace(/\$/g, ""))
    # Use googleapis api
    url = "https://chart.googleapis.com/chart?cht=tx&chl=#{expr}"
    util.richImageView msg, "LaTeX", url
