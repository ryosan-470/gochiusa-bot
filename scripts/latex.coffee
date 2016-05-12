# Description:
#   $$で囲まれたLaTeX形式の数式を返します
# Dependencies:
#   "hubot-slack-attachment"
#
# Commands:
#    $LaTeXCode$ => LaTeX picture
module.exports = (robot) ->
  robot.hear /\$.+?\$/, (msg) ->
    expr = encodeURIComponent(msg.match[0].replace(/\$/g, ""))
    # Use googleapis api
    url = "https://chart.googleapis.com/chart?cht=tx&chl=#{expr}"
    robot.emit 'slack.attachment',
    message: msg.message
    content: [
      fallback: "LaTeX"
      title: "LaTeX"
      title_link: url
      image_url: url
      color: "#764FA5"
    ]
