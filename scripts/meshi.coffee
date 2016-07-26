# Description:
#   飯機能をcole.jsから分離しました
#   引き続き"say cole 飯"も使えます
#
# Commands:
#    (昼飯|ランチ|飯|meshi) - 行頭のみcoleが飯屋を提案してくれる

list = require './data/meshi_shop.json'

module.exports = (robot) ->
  robot.hear /^(昼飯|ランチ|飯|meshi)/, (msg) ->
    randNum = (i) ->
      Math.floor(Math.random() * i)

    index = [-1, -1, -1]
    i = 0
    while (i < 3)
      num = randNum(list.length)
      if !(num in index)
        index[i] = num
        i++

    msg.send(":cole: ＜メシダガ、「" + list[index[0]] + "」「" + list[index[1]] + "」「" + list[index[2]] + "」ガイイトオモイマス.")
