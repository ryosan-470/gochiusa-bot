# Description:
#   新年だしおみくじでもしましょうか
#
# Commands:
#    omikuji / omikuzi - おみくじをします
module.exports = (robot) ->
  robot.hear /omikuji|omikuzi/, (msg) ->

    # 0からiまでの数をランダムに生成する関数randNum
    randNum = (i) ->
      Math.floor(Math.random() * i)

    # 運勢のリスト．追加したい運勢はここに書く
    unsei = ["大吉", "吉", "中吉", "小吉", "凶"]

    # くじ用の配列と合計数を記憶
    kuji = []
    total = 0

    # くじをセットする
    setKuji = ->
      str = ""
      for i in [0 ... unsei.length]
        num = randNum(10)
        if randNum(200) == 0
          num = 114514
        str += ("#{unsei[i]}: #{num}枚\n")
        while num--
          kuji.push(unsei[i])
          total++
      str += "が入っています\n"

    # くじを引く
    getKuji = ->
      if total > 0
        "あなたの運勢は「#{kuji[randNum(total)]}」です!"
      else
        "あなたはくじを引けませんでした"

    # main
    msg.send(setKuji())
    setTimeout ->
      msg.send("...\n")
    , 1000
    setTimeout ->
      msg.send("ジャジャーン!\n")
    , 2000
    setTimeout ->
      msg.send(getKuji())
    , 3000
