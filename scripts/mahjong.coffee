# Description:
#  麻雀
#
# Commands:
#    :mahjong / 麻雀  という言葉に反応して役を返します.
#    :%d翻%d符 /  という言葉で得点計算をします
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

# 10の位を切り上げ
carry10 = (num) ->
  Math.ceil(num / 100) * 100 # 小数にしてから小数点以下を切り捨てる

# 1の位を切り上げ
carry1 = (num) ->
  Math.ceil(num / 10) * 10   # 小数にしてから小数点以下を切り捨てる

module.exports = (robot) ->
  robot.hear /mahjong|麻雀|マージャン|まーじゃん/, (msg) ->
    head = msg.random heads
    hand = msg.random hands
    msg.send "#{head} #{hand}"

  robot.hear /(\d+)(翻|飜)(\d+)符/, (msg) ->
    han = parseInt(msg.match[1], 10)
    hu = parseInt(msg.match[3], 10)
    if (hu <= 10 and 110 < hu) or (han == 1 and hu <= 20) or han < 1
      msg.send "404 Not Found"
      return

    hu = carry1(hu) if hu != 25
    parent_ron = 0
    parent_tumo = 0
    children_ron = 0
    children_tumo4parent = 0
    children_tumo4children = 0

    if 1 <= han <= 4
        basic_point = hu * (2 ** (han + 2))
        if basic_point > 2000 then basic_point = 2000
        children_tumo4children = carry10(basic_point * 1)
        children_tumo4parent = carry10(basic_point * 2)
        children_ron = carry10(basic_point * 4)
        parent_tumo  = carry10(basic_point * 2)
        parent_ron = carry10(basic_point * 6)
    else if 5 <= han
        switch han
          when 5 then children_ron = 8000
          when 6, 7 then children_ron = 12000
          when 8, 9, 10 then children_ron = 16000
          when 11, 12 then children_ron = 24000
          when 13 then children_ron = 32000
          else children_ron = 32000
        children_tumo4parent = children_ron / 2
        children_tumo4children = children_ron / 4
        parent_ron = children_ron * 1.5
        parent_tumo = parent_ron / 3

    parent_ron = parent_ron.toString()
    parent_tumo = parent_tumo.toString()
    children_ron = children_ron.toString()
    children_tumo4parent = children_tumo4parent.toString()
    children_tumo4children = children_tumo4children.toString()
    msg.send """ロン：親は #{parent_ron} 点です
                      子は #{children_ron} 点です
                ツモ：親は #{parent_tumo} オールです
                      子は (#{parent_tumo} ,#{children_tumo4children}) です
             """

