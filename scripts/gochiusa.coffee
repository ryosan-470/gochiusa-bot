# Description:
#   ごちうさ画像 BOT
#
# Commands:
#    gochiusa / @gochiusa - 以下の画像をランダムで
#    こころ - こころぴょんぴょんと返す
# http://matome.naver.jp/odai/2139011062397372501内にある画像
gochiusa_img = require './data/gochiusa_matome.json'

module.exports = (robot) ->
  MyUtil = require("./myutil")
  util = new MyUtil(robot)

  robot.hear /ごちうさ/, (msg) ->
    url = msg.random gochiusa_img
    util.richImageView msg, "ご注文はうさぎですか?", url

  robot.hear /こころ/, (msg) ->
    msg.send "こころぴょんぴょん"
