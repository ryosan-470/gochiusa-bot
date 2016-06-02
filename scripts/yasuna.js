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

var fs = require('fs'); //ファイル読み書きライブラリ
var Canvas = require('canvas'); //node-canvas
var http = require('http'); //httpリクエスト
var path = require('path');
var mktemp = require('mktemp'); //mktemp

var Image = Canvas.Image;
var img = new Image;
var canvas;

(function(){
	module.exports=function(robot){
        var MyUtil = require("./myutil")
        var util = new MyUtil(robot)

		//入力された文章の取得
		return robot.hear(/yasuna(\s)(\S.*)/i,function(msg){
			var word = msg.match[2]; 

			//画像の生成
			fs.readFile(path.join(__dirname, 'data/yasuna.png'), function(err, data){ //ファイルの読み込み
				if(err) throw err;
				var img = new Image;
				img.src = data;
				canvas = new Canvas(img.width,img.height);				
				var ctx = canvas.getContext('2d');
	
				//canvasに画像を描画
				ctx.drawImage(img, 0, 0, img.width, img.height);
				
				
				// テキスト描画
				var margin = 7; //行間

				//一つ目の吹き出し
				var length = word.length; //文字数
				var fontsize1 = 20; //デフォルトフォントサイズ
				var text1 = [];//文章
				var x1 = 315;
				var y1 = 50;
				
				if(length <= 3){
					text1 = ["見たら本当に",
						"絶対" + word + "するよ！"];
				}else if(3 < length && length <= 5){
					text1 = ["見たら本当に絶対",
						word + "するよ！"];
				}else if (5 < length && length <= 8){
					x1 = 325;
					y1 = 55;
					text1 = ["見たら本当に絶対",
						 word,
						 "するよ！"];
					fontsize1 = 20;
				}else{
					x1 = 325;
					y1 = 55;
					text1 = ["見たら本当に絶対",
						 word,
						 "するよ！"];
					fontsize1 = 20 * 8 / length;
				}
				

				for(var i = 0; i < text1.length; i++){
					var x = x1 - (fontsize1 + margin) * i;
					var y = y1;
					ctx.fillStyle = 'rgba(0, 0, 0, 1.0)';
					tategaki(ctx, text1[i], x, y, fontsize1);
				}
				
				
				//二つ目の吹き出し
				var fontsize2 = 16;  //デフォルトのフォントの大きさ
				var text2 = [];
				var x2 = 65;
				var y2 = 40;
				
				if(length <= 3){
					text2 = ["もし" + word + "しなかったら",
						 "木の下に埋めてもらっても",
						 "構わないよ"
						];
				}else if(3 < length  && length <= 10){
					text2 = ["もし" + word ,
						 "しなかったら木の下に",
						 "埋めてもらっても構わないよ"
						];
					fontsize2 = 16 * 11 / 13; //16*11pxに13文字(3行目)が入るようにする
					
				}else if(10 < length){
					text2 = ["もし" + word ,
						 "しなかったら木の下に",
						 "埋めてもらっても構わないよ"
						];
					fontsize2 = 16 * 11 / (length + 2); //16*11pxに(length+2)文字(1行目)が入るようにする
				}

				for(var i = 0; i < text2.length; i++){
					var x = x2 - (fontsize2 + margin) * i;
					var y = y2;
					ctx.fillStyle = 'rgba(0, 0, 0, 1.0)';
					tategaki(ctx, text2[i], x, y, fontsize2);
				}
				 
				//pathの設定
				var temppath = path.join(__dirname, '..', 'tmp'); //保存先./tmpのpath
				var url = process.env.HEROKU_URL;
				if (url === undefined) {
					url = 'http://localhost:8080'; //画像表示先のURL
				}
				
				//保存先のディレクトリの有無の確認
				try {
					fs.statSync(temppath);
				} catch (e) {
					console.log(e);
					fs.mkdirSync(temppath, 0700);
				}
				
				//画像の保存
				mktemp.createFile(path.join(temppath,'XXXXXXXX.png'), function(err, filename) {
					var out = fs.createWriteStream(filename);
					var stream = canvas.pngStream();
					
					out.on('close', function() {
						var send_url = url + "/hubot/viewyasuna.png?id=" + path.basename(filename);
						util.richImageView(msg, "折部やすなー", send_url);
					});
					stream.on('data', function(chunk) {
						out.write(chunk);
					});
					stream.on('end', function(chunk) {
						out.end();
					});
				});	 
			});
		});
	}
}).call(this);


//文字を縦書きするメソッド
//http://tmlife.net/programming/javascript/html5-canvas-vertical-writing.html
var tategaki = function(context, text, x, y, fontsize) {
	var textList = text.split('\n');
	var lineHeight = fontsize;
	textList.forEach(function(elm, i) {
		Array.prototype.forEach.call(elm, function(ch, j) {
			context.font = fontsize + 'px "sans-serif"';
			var metrics = context.measureText(ch).width; //横幅
			if(ch == "っ")
				context.fillText(ch, x - metrics / 2 , y + lineHeight * (j - 1) + 5 * lineHeight / 6);
			else
				context.fillText(ch, x - metrics / 2 , y + lineHeight * j);
		});
	});
};


