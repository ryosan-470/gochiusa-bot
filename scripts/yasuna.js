// Description:
//   木の下に埋めてもらってもジェネレーターです。
//   「見たら本当に絶対hogehogeするよ！
//     もしhogehogeしなかったら木の下に埋めてもらっても構わないよ」
//
//   〜例1〜
//   hubot > yasuna 感動
//   hubot > 画像URL
//
// Commands:
//   yasuna 単語 - 画像URL
var fs = require('fs');
var Canvas = require('canvas');
var path = require('path');

var Image = Canvas.Image;
var Font = Canvas.Font;

var fontFile = function(name) {
  return path.join(__dirname, '/../.fonts/', name);
};

// 文字を縦書きするメソッド
// http://tmlife.net/programming/javascript/html5-canvas-vertical-writing.html
var tategaki = function(context, text, x, y, fontsize) {
  var textList = text.split('\n');
  var lineHeight = fontsize;
  textList.forEach(function(elm, i) {
    Array.prototype.forEach.call(elm, function(ch, j) {
      context.font = fontsize + "px NotoSansCJKjp-Regular";
      var metrics = context.measureText(ch).width; // 横幅
      if (ch === "っ") {
        context.fillText(ch, x - metrics / 2,
                         y + lineHeight * (j - 1) + 5 * lineHeight / 6);
      } else {
        context.fillText(ch, x - metrics / 2, y + lineHeight * j);
      }
    });
  });
};

var drawedCanvas = function(baseImage, word) {
  var canvas = new Canvas(365, 534);
  var ctx = canvas.getContext('2d');
  ctx.drawImage(baseImage, 0, 0);
  //  テキスト描画
  var margin = 7; // 行間

  // 一つ目の吹き出し
  var length = word.length; // 文字数
  var fontsize1 = 20; // デフォルトフォントサイズ
  var text1 = [];// 文章
  var x1 = 315;
  var y1 = 50;

  if (length <= 3) {
    text1 = ["見たら本当に",
             "絶対" + word + "するよ！"];
  } else if (length > 3 && length <= 5) {
    text1 = ["見たら本当に絶対",
             word + "するよ！"];
  } else if (length > 5 && length <= 8) {
    x1 = 325;
    y1 = 55;
    text1 = ["見たら本当に絶対",
             word,
             "するよ！"];
    fontsize1 = 20;
  } else {
    x1 = 325;
    y1 = 55;
    text1 = ["見たら本当に絶対",
             word,
             "するよ！"];
    fontsize1 = 20 * 8 / length;
  }
  var i;
  var x;
  var y;
  for (i = 0; i < text1.length; i++) {
    x = x1 - (fontsize1 + margin) * i;
    y = y1;
    ctx.fillStyle = 'rgba(0, 0, 0, 1.0)';
    tategaki(ctx, text1[i], x, y, fontsize1);
  }

  // 二つ目の吹き出し
  var fontsize2 = 16;  // デフォルトのフォントの大きさ
  var text2 = [];
  var x2 = 65;
  var y2 = 40;

  if (length <= 3) {
    text2 = ["もし" + word + "しなかったら",
             "木の下に埋めてもらっても",
             "構わないよ"
            ];
  } else if (length > 3 && length <= 10) {
    text2 = ["もし" + word,
             "しなかったら木の下に",
             "埋めてもらっても構わないよ"
            ];
    fontsize2 = 16 * 11 / 13; // 16*11pxに13文字(3行目)が入るようにする
  } else if (length > 10) {
    text2 = ["もし" + word,
             "しなかったら木の下に",
             "埋めてもらっても構わないよ"
            ];
    fontsize2 = 16 * 11 / (length + 2); // 16*11pxに(length+2)文字(1行目)が入るようにする
  }

  for (i = 0; i < text2.length; i++) {
    x = x2 - (fontsize2 + margin) * i;
    y = y2;
    ctx.fillStyle = 'rgba(0, 0, 0, 1.0)';
    tategaki(ctx, text2[i], x, y, fontsize2);
  }

  return canvas;
};

var sendImage = function(req, res) {
  fs.readFile(path.join(__dirname, 'data/yasuna.png'), function(err, data) {
    if (err) {
      console.log(err);
    }
    var img = new Image();
    img.src = data;

    var canvas = drawedCanvas(img, req.query.word || "感動");

    res.writeHead(200, {"Content-Type": "image/png"});
    canvas.toBuffer(function(err, buf) {
      if (err) {
        console.log(err);
        res.end();
        return;
      }
      res.end(buf);
    });
  });
};

exports.init = function(req, res) {
  sendImage(req, res);
};
