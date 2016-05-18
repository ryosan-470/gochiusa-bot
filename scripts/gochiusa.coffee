# Description:
#   ごちうさ画像 BOT
#
# Commands:
#    gochiusa / @gochiusa - 以下の画像をランダムで
#    こころ - こころぴょんぴょんと返す
# http://matome.naver.jp/odai/2139011062397372501内にある画像
gochiusa_img = require './data/gochiusa_matome.json'

module.exports = (robot) ->
  robot.hear /ごちうさ/, (msg) ->
    url = msg.random gochiusa_img
    robot.emit 'slack.attachment',
    message: msg.message
    content: [
      fallback: "ごちうさ"
      title: "ごちうさ"
      title_link: url
      image_url: url
    ]

  robot.hear /こころ/, (msg) ->
    msg.send "こころぴょんぴょん"
