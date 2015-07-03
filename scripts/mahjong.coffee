# Description:
#  麻雀
#
# Commands:
#    :mahjong / 麻雀  という言葉に反応して役を返します.
#    :%d翻%d符 /  という言葉で得点計算をします
#
# Documentation:
#  麻雀の役を登録するルールとして雀頭が予め登録してあり面子4つと組み合わせて出力することにします.
#

module.exports = (robot) ->
  robot.hear /mahjong|麻雀|マージャン|まーじゃん/, (msg) ->

    # 使った牌の個数を記憶しておく
    count = [
      0, 0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0
      ]

    # 使った赤ドラを記憶しておく(左から萬子，索子，筒子)
    useDora = [false, false, false]

    # 鳴いたかどうか確かめる．一発，鳴いちゃった罵倒判定に使用
    naita = false

    # 槓子の個数
    kantsu = 0

    # 0からiまでの数をランダムに生成する関数randNum
    randNum = (i) ->
      Math.floor(Math.random() * i)

    ###
    * 0から33までの値を受け取ると対応する牌を返す関数int2hai
    * 5の牌に関しては，適当に1つだけ赤ドラを出す
    ###
    int2hai = (n) ->
      switch n
        when 0 then return ":1man:"
        when 1 then return ":2man:"
        when 2 then return ":3man:"
        when 3 then return ":4man:"
        when 4 then return hai5(0)
        when 5 then return ":6man:"
        when 6 then return ":7man:"
        when 7 then return ":8man:"
        when 8 then return ":9man:"
        when 9 then return ":1so:"
        when 10 then return ":2so:"
        when 11 then return ":3so:"
        when 12 then return ":4so:"
        when 13 then return hai5(1)
        when 14 then return ":6so:"
        when 15 then return ":7so:"
        when 16 then return ":8so:"
        when 17 then return ":9so:"
        when 18 then return ":1pin:"
        when 19 then return ":2pin:"
        when 20 then return ":3pin:"
        when 21 then return ":4pin:"
        when 22 then return hai5(2)
        when 23 then return ":6pin:"
        when 24 then return ":7pin:"
        when 25 then return ":8pin:"
        when 26 then return ":9pin:"
        when 27 then return ":hai-haku:"
        when 28 then return ":hai-hatsu:"
        when 29 then return ":hai-chun:"
        when 30 then return ":hai-ton:"
        when 31 then return ":hai-nan:"
        when 32 then return ":hai-sha:"
        when 33 then return ":hai-pei:"
        else return ":bug:" # bug発見用

    # 赤ドラを出したい
    hai5 = (i) ->
      if !useDora[i]
        # 残っている牌のうち，赤ドラを引く確率
        j = randNum(4 - count[4 + i * 9])
        if j == 0
          useDora[i] = true
          i += 3
      switch i
        when 0 then return ":5man:"
        when 1 then return ":5so:"
        when 2 then return ":5pin:"
        when 3 then return ":5mana:"
        when 4 then return ":5soa:"
        when 5 then return ":5pina:"

    ###
    * 七対子の実装
    * 適当に7種類選び，出力するだけ
    ###
    toitsu7 = ->
      str = ""
      for i in [0 .. 6]
        # 使ってない牌を探す
        while true
          j = randNum(34)
          if count[j] == 0
            break
        count[j]++
        str += int2hai(j) + int2hai(j) + " "
      return str

    ###
    * 国士無双の実装
    * tは2枚使う牌を指定
    * ychは使用牌の集合
    ###
    kokushi = ->
      t = randNum(13)
      ych = [0, 8, 9, 17, 18, 26, 27, 28, 29, 30, 31, 32, 33]
      str = ""
      for i in [0 .. 12]
        if i == t
          str += int2hai(ych[i]) + int2hai(ych[i])
        else
          str += int2hai(ych[i])
      return str

    ###
    * 4面子1雀頭の生成
    * 雀頭を設定した後，順子か刻子を4個後ろにつける
    * 順子：刻子 = 1 : 1
    ###
    normal = ->
      str = ""
      # 雀頭の生成
      head = randNum(34)
      count[head] += 2
      str += int2hai(head) + int2hai(head) + " "
      # 面子を4つ作る
      for i in [0 .. 3]
        # 順子にするか，刻子にするか
        j = randNum(2)
        if j == 0
          mentsu = kotsu()
        else
          mentsu = shuntsu()
        # 順子の場合，鳴く確率は1/5．刻子の場合，鳴く確率は1/3
        if (randNum(2 * j + 3)) == 0
          naita = true
          str += "(" + mentsu + ") "
        else
          str += mentsu + " "
      return str

    shuntsu = ->
      while true
        i = randNum(21)
        i += (Math.floor(i / 7)) * 2
        if (count[i] < 4 and count[i + 1] < 4 and count[i + 2] < 4)
          break
      count[i]++
      count[i + 1]++
      count[i + 2]++
      return int2hai(i) + int2hai(i + 1) + int2hai(i + 2)

    kotsu = ->
      while true
        i = randNum(34)
        if count[i] < 2
          break
      # 牌が1枚も使われていないとき，20%の確率で槓子になる
      if count[i] == 0 and (randNum(5)) == 0
        count[i] += 4
        kantsu++
        return "[" + int2hai(i) + int2hai(i) + int2hai(i) + int2hai(i) + "]"
      count[i] += 3
      return int2hai(i) + int2hai(i) + int2hai(i)

    # ドラの生成
    makeDora = ->
      while true
        i = randNum(34)
        if count[i] < 4
          break
      count[i]++
      return int2hai(i)

    # 槓ドラ，裏ドラ
    addDora = ->
      str = "追加ドラ"
      if !naita
        for i in [0 .. kantsu]
          str += makeDora()
      for i in [0 ... kantsu]
        str += makeDora()
      return str

    # ドラ，風を表示する
    kaze_and_firstDora = ->
      return "ドラ表示" + makeDora() + " 場風" + int2hai((randNum(4)) + 30) + " 自風" + int2hai((randNum(4)) + 30)

    ###
    * main
    * 1%で国士無双，5%で七対子，94%でその他
    * チノちゃん風にコメントを出す
    * 鳴いた場合，33%の確率で罵倒される
    * 鳴かない場合，10%の確率で一発
    ###
    msg.send "#{kaze_and_firstDora()}"
    n = randNum(100)
    if n < 1
      msg.send "#{kokushi()}"
    else if n < 6
      msg.send "#{toitsu7()}"
    else
      msg.send "#{normal()}"
      if (!naita or kantsu > 0)
        msg.send "#{addDora()}"
      if naita and (randNum(3)) == 0
        msg.send "何で鳴いちゃったんですか? バカなんですか?"
    if !naita and (randNum(10)) == 0
      msg.send "一発ですよ! すごい!"


  robot.hear /(\d+)(翻|飜)(\d+)符/, (msg) ->

    # 10の位を切り上げ
    carry10 = (num) ->
      Math.ceil(num / 100) * 100 # 小数にしてから小数点以下を切り捨てる

    # 1の位を切り上げ
    carry1 = (num) ->
      Math.ceil(num / 10) * 10   # 小数にしてから小数点以下を切り捨てる

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
    msg.send """ロン：親は #{parent_ron}点 です
                      子は #{children_ron}点 です
                ツモ：親は #{parent_tumo}点 オールです
                      子は (#{parent_tumo}点, #{children_tumo4children}点) です
             """
