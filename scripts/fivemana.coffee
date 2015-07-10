# Description:
#   5mana画像 BOT
#
# Commands:
#    5mana / @5mana - 画像をランダムで
mana_img = require './data/5mana_matome.json'

module.exports = (robot) ->
  robot.hear /5mana/, (msg) ->
    msg.send msg.random mana_img

