# Description
#   myutil.coffee
#   基本的には他のファイルでも利用できるスクリプトをまとめる.
#   使い方としては最初に
#       MyUtil = require('./myutil)
#       util = new MyUtil(robot)
#   をしたのち, utilに定義されているメソッドを呼び出すことで利用ができる
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
