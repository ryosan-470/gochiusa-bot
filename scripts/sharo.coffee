# Description:
#   桐間紗路 BOT
#
# Commands:
#    :sharo / @sharo - 以下のセリフからランダムで
sharo = [
  "https://pbs.twimg.com/media/CCzW7sGVAAADhnd.jpg",
  "http://bit.ly/1GkQlLJ"
  ]

module.exports = (robot) ->
  robot.hear /:sharo|@sharo/, (msg) ->
    msg.send msg.random sharo
