// Description:
//   しりとりをします。
//
// Commands:
//  しりとりの開始
//  hubot > しりとり りんご
//  hubot > ゴリラ
//
//  しりとりのリセット
//  hubot > reset しりとり
//  hubot > しりとりをやり直します.

// robot.brainのKey
var BRAIN_KEY = "shiritori";

(function() {
  var url = "https://api.apigw.smt.docomo.ne.jp/dialogue/v1/dialogue";
  var apiKey = process.env.DOCOMO_API_KEY;
  module.exports = function(robot) {
    // しりとりの開始／継続
    robot.hear(/(shiritori|しりとり)(\s*)(\S+)/i, function(msg) {
      var requestUrl = url + "?APIKEY=" + apiKey;
      // BRAINからcontextを取得
      var context = robot.brain.get(BRAIN_KEY);
      // APIに渡すためのデータ
      var data;
      data = JSON.stringify({
        "utt": msg.match[3],
        "context": context,
        "mode": "srtr" // しりとりモード
      });
      return robot.http(requestUrl).header("Content-type", "application/json").post(
        data)(function(err, res, body) {
          var result = JSON.parse(body);
          var resWord = result.utt;
          robot.brain.set(BRAIN_KEY, result.context);
          return msg.send(resWord);
        });
    });

    // しりとりのリセット
    robot.hear(/reset(\s*)(shiritori|しりとり)/i, function(msg) {
      // BRAINのリセット
      robot.brain.set(BRAIN_KEY, null);
      return msg.send("しりとりをやり直します.");
    });
  };
}).call(this);
