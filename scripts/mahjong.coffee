# Description:
#   麻雀
#
# Commands:
#    :mahjong / 麻雀  という言葉に反応して役を返します.
#    :point %d han  /  という言葉で得点計算をします
hands = [
    ":2so: :2so: :3so: :3so: :4so: :4so: :6so: :6so: :6so: :8so: :8so: :hai-hatsu: :hai-hatsu: :hai-hatsu:",
    ":1man: :1man: :1man: :2man: :2man: :2man: :5so: :6so: :7so: :hai-ton: :hai-ton: :hai-ton: :hai-nan: :hai-nan:",
    ":1pin: :1pin: :1pin: :1so: :2so: :3so: :4pin: :5pin: :6pin: :hai-nan::hai-nan::hai-nan: :hai-sha::hai-sha:",
    ":9man: :1pin: :9pin: :1so: :9so: :hai-haku: :hai-hatsu: :hai-chun: :hai-ton: :hai-nan: :hai-sha: :hai-pei:",
    ":1man: :9man: :1pin: :9pin: :1so: :9so: :hai-haku: :hai-hatsu: :hai-chun: :hai-ton: :hai-nan: :hai-sha: :hai-pei:",
    ":1man: :9man: :1pin: :9pin: :1so: :9so: :hai-haku: :hai-hatsu: :hai-chun: :hai-ton: :hai-nan: :hai-sha: :hai-pei:",
    ":1man: :9man: :1pin: :9pin: :1so: :9so: :hai-haku: :hai-hatsu: :hai-chun: :hai-ton: :hai-nan: :hai-sha: :hai-pei:",
    ":1man: :1man: :1pin: :1pin: :1pin: :1so: :1so: :1so: :9man: :9man: :9man: :9pin: :9pin:",
    ]

module.exports = (robot) ->
  robot.hear /mahjong|麻雀|マージャン|まーじゃん/, (msg) ->
    msg.send msg.random hands

  robot.hear /point (\d+) han/, (msg) ->
    han = parseInt(msg.match[1], 10)
    parent_point = 0
    children_point = 0

    console.log han
    switch han
      when 1
        children_point = 1000
      when 2
        children_point = 2000
      when 3
        children_point = 3300
      when 4
        children_point = 7700
      when 5
        children_point = 8000
      when 6
        children_point = 12000
      when 7
        children_point = 12000
      when 8
        children_point = 16000
      when 9
        children_point = 16000
      when 10
        children_point = 16000
      when 11
        children_point = 24000
      when 12
        children_point = 24000
      when 13
        children_point = 32000
      else
        children_point = 32000

    parent_point = children_point * 1.5

    parent_point = parent_point.toString()
    children_point = children_point.toString()
    msg.send "親は #{parent_point} 点. 子は #{children_point} 点です"
