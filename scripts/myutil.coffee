# 便利な関数をまとめておくだけのスクリプト
# Hubot本体にはあまり関係ないかも
module.exports = class MyUtil
  @robot = null

  constructor: (robot) ->
    @robot = robot

  richImageView: (msg, title, url) ->
    @robot.emit 'slack.attachment',
    message: msg.message
    content: [
      title: title
      title_link: url
      image_url: url
    ]
