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
    if (category.indexOf("定食") !== -1 || category.indexOf("和食") !== -1 || category.indexOf("米") !== -1) {
      Array.prototype.push.apply(list, dict.Japanese);
    }
    if (category.indexOf("中華") !== -1) {
      Array.prototype.push.apply(list, dict.Chinese);
    }
    if (category.indexOf("ラーメン") !== -1) {
      Array.prototype.push.apply(list, dict.Ramen);
    }
    if (category.indexOf("洋食") !== -1 || category.indexOf("ピザ") !== -1 || category.indexOf("レストラン") !== -1) {
      Array.prototype.push.apply(list, dict.Restaurant);
    }
    if (category.indexOf("ファストフード") !== -1) {
      Array.prototype.push.apply(list, dict.FastFood);
    }
    if (category.indexOf("学食") !== -1) {
      Array.prototype.push.apply(list, dict.School);
    }
    // 何にも該当しなかった場合
    if (list.length === 0) {
      for (var key in dict) {
        Array.prototype.push.apply(list, dict[key]);
      }
    }

    // リストの重みの合計を求める
    var weightSum = 0;
    for (var t = 0; t < list.length; t++) {
      weightSum += list[t].weight;
    }

    // 乱数を生成する関数
    var randNum = function(i) {
      return Math.floor(Math.random() * i);
    };

    var ansNum = Math.min(3, list.length); // 答えの数
    var ansIndex = []; // 答えとなる要素のインデックス
    var count = 0;

    while (ansIndex.length < ansNum) { // 決められた数答えが決定するまで
      count++;
      if (count > 100) {  // 100回試行しても決まらない場合
        break;
      }

      var rand = randNum(weightSum); // 乱数の生成
      var tmpSum = 0; // 重みの累積分布
      var num; // 乱数から選ばれた要素のインデックス
      // 重みと乱数からどの要素が選ばれたか計算する
      for (var listIndex = 0; listIndex < list.length; listIndex++) {
        if (tmpSum <= rand && rand <= tmpSum + list[listIndex].weight) {
          num = listIndex; // 決定
          break;
        }
        tmpSum += list[listIndex].weight; // 累積
      }

      // 昼営業判定
      if (lunchDinner === 0 && (!list[num].isLunch)) {
        continue;
      }
      // 夜営業判定
      if (lunchDinner === 1 && (!list[num].isDinner)) {
        continue;
      }
      if (ansIndex.indexOf(num) === -1) {
        ansIndex.push(num);
      }
    }
    // 答えの文の生成
    var ans1;
    if (lunchDinner === 0) {
      ans1 = "ヒルメシ";
    } else if (lunchDinner === 1) {
      ans1 = "ユウメシ";
    } else {
      ans1 = "メシ";
    }
    var ans2 = "";
    for (var i1 = 0; i1 < ansIndex.length; i1++) {
      ans2 += "「" + list[ansIndex[i1]].storeName + "」";
    }
    var ans;
    if (ansIndex.length === 0) {  // 店が見つからなかった場合
      ans = ":cole: ＜" + ans1 + "ダガ、...スイマセンミツカリマセンデシタ.";
    } else {
      ans = ":cole: ＜" + ans1 + "ダガ、" + ans2 + "ガイイトオモイマス.";
    }
    return msg.send(ans);
  });
};
