// Description:
// 飯機能をcole.jsから分離しました
//   引き続き"say cole 飯"も使えます
//
// Commands:
//    (飯) - 行頭のみ.coleが飯屋を提案してくれる
//    ({昼|夕}飯) - 昼夜を考慮して飯屋を提案してくれる
//    ({昼|夕}?飯 category) - カテゴリを絞って飯屋を提案してくれる

var dict = require('./data/meshi_shop.json');

module.exports = function(robot) {
  return robot.hear(/^(昼|夕)?飯\s?((\s|\S)*)$/, function(msg) {
    var lunchDinner = -1;
    var category = msg.match[2];
    // 昼夜の判定
    if (msg.match[1] !== undefined) {
      if (msg.match[1].indexOf("昼") !== -1) {
        lunchDinner = 0;
      } else if (msg.match[1].indexOf("夕") !== -1) {
        lunchDinner = 1;
      }
    }
    // カテゴリを絞る
    var list = [];
    if (category.indexOf("定食") >= 0) {
      Array.prototype.push.apply(list, dict.Japanese);
    } else if (category.indexOf("中華") >= 0) {
      Array.prototype.push.apply(list, dict.Chinese);
    } else if (category.indexOf("ラーメン") >= 0) {
      Array.prototype.push.apply(list, dict.Ramen);
    } else if (category.indexOf("洋食") >= 0 || category.indexOf("ピザ") >= 0 || category.indexOf("レストラン") >= 0) {
      Array.prototype.push.apply(list, dict.Restaurant);
    } else if (category.indexOf("ファストフード") >= 0) {
      Array.prototype.push.apply(list, dict.FastFood);
    } else if (category.indexOf("学食") >= 0) {
      Array.prototype.push.apply(list, dict.School);
    } else {
      for (var key in dict) {
        Array.prototype.push.apply(list, dict[key]);
      }
    }
    // 乱数を生成する関数
    var randNum = function(i) {
      return Math.floor(Math.random() * i);
    };
    var ansNum = Math.min(3, list.length);
    var index = [];
    for (var i = 0; i < ansNum; i++) {
      index.push(-1);
    }
    var count = 0;
    while (count < ansNum) {
      var num = randNum(list.length);
      // 昼営業判定
      if (lunchDinner === 0 && (!list[num].isLunch)) {
        continue;
      }
      // 夜営業判定
      if (lunchDinner === 1 && (!list[num].isDinner)) {
        continue;
      }
      if (index.indexOf(num) === -1) {
        index[count] = num;
        count++;
      }
    }
    // 答えの生成
    var ans1;
    if (lunchDinner === 0) {
      ans1 = "ヒルメシ";
    } else if (lunchDinner === 1) {
      ans1 = "ユウメシ";
    } else {
      ans1 = "メシ";
    }
    var ans2 = "";
    for (var t = 0; t < ansNum; t++) {
      ans2 += "「" + list[index[t]].storeName + "」";
    }
    return msg.send(":cole: ＜" + ans1 + "ダガ、" + ans2 + "ガイイトオモイマス.");
  });
};
