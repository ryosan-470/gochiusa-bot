# Description:
#   桐間紗路 BOT
#
# Commands:
#    :sharo / @sharo - 以下のセリフからランダムで
sharo = [
  "https://pbs.twimg.com/media/CCzW7sGVAAADhnd.jpg",
  "http://marticleimage.nicoblomaga.jp/image/51/2014/8/9/89333b248c4e6b6763d7e1832e6fba0c43853da71402583543.jpg"
  ]

module.exports = (robot) ->
  robot.hear /sharo|@sharo/, (msg) ->
    msg.send msg.random sharo
