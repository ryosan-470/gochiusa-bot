# Description:
#  麻雀
#
# Commands:
#    :mahjong / 麻雀  という言葉に反応して役を返します.
#    :point %d han  /  という言葉で得点計算をします
#
# Documentation:
#  麻雀の役を登録するルールとして雀頭が予め登録してあり面子4つと組み合わせて出力することにします.
#  きちんと考えて書かないと字牌が5個とか出てしまうので考えてかいてください. (特に順子を追加するとき)
#
# 雀頭
heads = [
  ":hai-ton: :hai-ton:",     # 東
  ":hai-sha: :hai-sha:",     # 西
  ":hai-nan: :hai-nan:",     # 南
  ":hai-pei: :hai-pei:",     # 北
  ":hai-hatsu: :hai-hatsu:", # 発
  ":hai-chun: :hai-chun:",   # 中
  ":hai-haku: :hai-haku:",   # 白
]

# 役(面子が4つ)
hands = [
  ":1man: :2man: :3man: :4man: :5man: :6man: :7man: :8man: :9man: :1so: :2so: :3so:",
  ":hai-ton: :1man: :2man: :3man: :4man: :5man: :6man: :7man: :8man: :9man: :1so: :1so:",
]

module.exports = (robot) ->
  robot.hear /mahjong|麻雀|マージャン|まーじゃん/, (msg) ->
    head = msg.random heads
    hand = msg.random hands
    msg.send "#{head} #{hand}"

  robot.hear /point (\d+) han/, (msg) ->
    han = parseInt(msg.match[1], 10)
    parent_point = 0
    children_point = 0

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
