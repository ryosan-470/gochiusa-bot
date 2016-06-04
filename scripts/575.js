// Description:
//   文章が575の場合、教えてくれます。
//
// Commands:
//  hubot > 任意の575の文字列
//  hubot > add-reaction :goshichigo:
//
/*
 add-reactionするメソッド
 参考記事：
 HubotでSlackのEmoji Reactionを付ける
 http://qiita.com/hiconyan/items/f2c37a10ac2c581693ce
 */
var request = require('request');

(function() {
  var url = "https://labs.goo.ne.jp/api/morph";
  var APP_ID = process.env.GOO_APP_ID;
  if (!APP_ID) {
    console.error("error: Set your GOO_APP_ID env variables.");
  }
  module.exports = function(robot) {
    var addReactions = function(msg, name) {
      var options = {
        "url": 'https://slack.com/api/reactions.add',
        "qs": {
          "token": process.env.HUBOT_SLACK_TOKEN,
          "name": name,
          "channel": msg.message.rawMessage.channel,
          "timestamp": msg.message.rawMessage.ts
        }
      };
      return request.post(options, function(err, res, body) {
        if ((err !== null) || res.statusCode !== 200) {
          return robot.logger.error(
            "Failed to add emoji reaction " + (JSON.stringify(err)));
        }
      });
    };

    // 入力された文章の取得
    return robot.hear(/.*/i, function(msg) {
      // APIに渡すためのデータ
      var data;
      data = JSON.stringify({
        "app_id": APP_ID,
        "sentence": msg.match[0]
      });
      return robot.http(url).header("Content-type", "application/json").post(
        data)(function(err, res, body) {
          var result = JSON.parse(body);
          var sentence = result.word_list;
          if (is575(sentence)) {
            return addReactions(msg, "575");
          }
        });
    });
  };
}).call(this);

/**
 * 575かどうかを判定するメソッド
 * @param {string} sentence
 * @return boolean
 */
function is575(sentence) {
  var count = [0, 0, 0];
  var countLim = [5, 7, 5];
  var nowWatch = 0;
  for (var i in sentence) { // 行
    for (var j in sentence[i]) { // 列
      var word = sentence[i][j];
      if (word[2] === "＄") {  // 読めない文字は無視
        continue;
      }
      if (word[2] === "ァ" || word[2] === "ィ" || word[2] === "ゥ" ||
          word[2] === "ェ" || word[2] === "ォ" || word[2] === "ャ" ||
          word[2] === "ュ" || word[2] === "ョ" || word[2] === "ッ") { // 小文字のみは無視
        continue;
      }
      // 575達成後に読める文字が存在してしまう場合
      if (nowWatch > 2) {
        return false;
      }
      var isJoshi = (word[1].indexOf("助") !== -1);           // 助詞の判定
      var isHanteishi = (word[1].indexOf("判") !== -1);       // 判定詞の判定
      var isSetsubiji = (word[1].indexOf("接尾") !== -1);     // 接尾辞の判定
      var isKatsuyougobi = (word[1].indexOf("語尾") !== -1);  //  活用語尾の判定

      // 575の最初が助詞、判定詞になってしまう場合、falseを返す
      if ((isJoshi || isHanteishi || isSetsubiji || isKatsuyougobi) &&
          count[nowWatch] === 0) {
        return false;
      }
      var wordReading = word[2].replace(/ャ|ュ|ョ|ァ|ィ|ゥ|ェ|ォ/g, ""); // 小さい文字の削除
      count[nowWatch] += wordReading.length;

      // 文字数の判定
      if (count[nowWatch] > countLim[nowWatch]) {
        return false;
      } else if (count[nowWatch] === countLim[nowWatch]) {
        nowWatch++;
      }
    }
  }
  if (nowWatch === 3) {
    return true;
  }
  return false;
}
