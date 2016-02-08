# Description:
#    misc.coffee
#    なんか書いたけどほんとに必要なのかわからない謎機能をまとめる
#
# Commands:
#    :c2e / man - 入力文字から :*-man: あるいは :*-num: という形の文字列を返す
#    :煽り|あおり - 煽り画像から適当に返す
#     From http://matome.naver.jp/odai/2141429957064254801
#
#    :hoge like fuga - 'わぁいfuga hogefuga大好き'と返す
#    :like fuga - 'わぁいfuga あかりfuga大好き'と返す
#
#    :say ho hoge - ':youtherock:＜ ドウナンダhogeトシテー！Yeah！'と返す
#
#    :say 114514 - 乱数で'114514'という数列が現れるかどうか。
#                  500回以内に出せたら回数を出力。失敗したら終了


#乱数の生成メソッド
getRandomInt = (min, max) ->
  Math.floor(Math.random() * (max - min + 1)) + min

aori_img = require './data/aori.json'

module.exports = (robot) ->
  robot.hear /c2e ([A-Za-z\d ]+$)/, (msg) ->  # 大文字小文字のアルファベット，数字を受理
    result = ""
    for r in msg.match[1].toLowerCase()     # すべての文字を小文字に変換
      if r == " "
        result += "  "
      else if /[0-9]/.test(r)
        result += ":" + r + "num:"
      else
        result += ":" + r + "-man:"
    msg.send result

  robot.hear /煽り|あおり/, (msg) ->
    msg.send msg.random aori_img

  robot.hear /(\s*|\S*\s*)like(\s*)(\S+)/i, (msg) ->
    name = msg.match[1].trim()  #空白の削除
    thing = msg.match[3]
    if name == ''
      name = 'あかり'
    msg.send 'わぁい' + thing + ' ' + name + thing + '大好き'

  robot.hear /say(\s*)ho(\s*)(\S+)/i, (msg) ->
    thing = msg.match[3]
    msg.send ':youtherock:＜ ドウナンダ' + thing + 'トシテー！Yeah！'


  robot.hear /say(\s*)114514/i, (msg) ->
    count = 0
    record = ''
    koiyo = -1
    selectList = [1,4,5]
    while count < 500
      count++
      tmp = selectList[getRandomInt(0, 2)]
      record += String(tmp)
      if koiyo == -1 and tmp == 1
        koiyo = 1
      else if koiyo == 1 and tmp == 1
        koiyo = 2
      else if koiyo == 2 and tmp == 4
        koiyo = 3
      else if koiyo == 3 and tmp == 5
        koiyo = 4
      else if koiyo == 4 and tmp == 1
        koiyo = 5
      else if koiyo == 5 and tmp == 4
        return msg.send(record + '!\n' + count + '回目でチャレンジ成功!\n:yaju: ＜やったぜ。')
      else
        koiyo = -1
    msg.send record + '!\nチャレンジ失敗\n:yaju: ＜ｻﾞﾝﾈﾝ'
