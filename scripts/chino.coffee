# Description:
#   香風智乃 BOT
#
# Commands:
#    :chino / @chino - 以下のセリフからランダムで


chino = [
  "妹じゃないです",
  "酵母菌? そんな危険な物入れるくらいならバサバサパンで我慢します",
  ]

module.exports = (robot) ->
  robot.hear /:chino|@chino/, (msg) ->
    msg.send msg.random chino

  robot.hear /(眠|ねむ)い/i, (msg) ->
    msg.send msg.random [
      "お兄ちゃんのねぼすけ",
    ]
