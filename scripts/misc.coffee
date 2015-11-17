# Description:
#    misc.coffee
#    なんか書いたけどほんとに必要なのかわからない謎機能をまとめる
#
# Commands:
#    :c2e / man - 入力文字から :*-man: あるいは :*-num: という形の文字列を返す
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
