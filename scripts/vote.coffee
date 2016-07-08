# Description:
#   0-10までの選択肢，曜日の絵文字をadd-reaction表示してくれるよ
#
# Commands:
#    (vote / 投票) num1-num2         - num1からnum2までadd reaction
#    (vote / 投票) (平日 / weekdays) - 平日曜日をadd reaction
#    (vote / 投票) (週間 / a week)   - 週間曜日をadd reaction
#
# Issue:
#   今後, Emojiの出力がランダムになる案件を解決したい

request = require('request')

module.exports = (robot) ->
  addReactions = (msg, name) ->
    options = {
      url: 'https://slack.com/api/reactions.add'
      qs: {
        'token': process.env.HUBOT_SLACK_TOKEN
        'name': name
        'channel': msg.message.rawMessage.channel
        'timestamp': msg.message.rawMessage.ts
      }
    }
    request.post options, (err, res, body) ->
      if err? or res.statusCode isnt 200
        robot.logger.error("Failed to add emoji reaction #{JSON.stringify(err)}")

  reaction = (list, st, en, msg) ->
    setTimeout ->
      addReactions(msg, list[st])
      list.shift()
      if en > 0
        reaction(list, st, en - 1, msg)
    , 650

  robot.hear /(vote|投票)(\s*)(\d+)-(\d+)/, (msg) ->
    st = parseInt(msg.match[3], 10)
    en = parseInt(msg.match[4], 10)

    if !(0 <= st < 10 and 0 < en <= 10 and st < en)
      msg.send "数の絵文字が見つかりません"
    else
      en -= st
      reaction(["zero", "one", "two", "three", "four", "five", "six",
      "seven", "eight", "nine", "keycap_ten"], st, en, msg)

  robot.hear /(vote|投票)(\s*)(平日|weekdays)/, (msg) ->
    reaction(["monday", "tuesday", "wednesday", "thursday", "friday"],
    0, 4, msg)

  robot.hear /(vote|投票)(\s*)(週間|a\sweek)/, (msg) ->
    reaction(["monday", "tuesday", "wednesday", "thursday", "friday",
    "saturday", "sunday"], 0, 6, msg)
