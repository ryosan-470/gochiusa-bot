var fs = require('fs'); //ファイル読み書きライブラリ
var Canvas = require('canvas'); //node-canvas
var http = require('http'); //httpリクエスト


var Image = Canvas.Image;
var img = new Image;
var canvas;

(function(){
	module.exports=function(robot){	    
		//入力された文章の取得
		return robot.hear(/yasuna(\s)(\S.*)/i,function(msg){
			var word = msg.match[1]; 
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
				var fontsize1 = 20;  //フォントの大きさ
				
				var text11 = "見たら本当に";
				var x11 = 310;
				var y11 = 50;
				ctx.fillStyle = 'rgba(0, 0, 0, 1.0)';
				tategaki(ctx, text11, x11, y11, fontsize1);
				
				var text12 = "絶対" + word + "するよ！";
				var x12 = x11 - (fontsize1 + margin);
				var y12 = y11;
				tategaki(ctx, text12, x12, y12, fontsize1);
				
				
				//二つ目の吹き出し
				var fontsize2 = 16;  //フォントの大きさ
				
				var text21 = "もし" + word + "しなかったら";
				var x21 = 65;
				var y21 = 40;
				tategaki(ctx, text21, x21, y21, fontsize2);
				
				var text22 = "木の下に埋めて貰っても";
				var x22 = x21 - (fontsize2 + margin);
				var y22 = y21;
				tategaki(ctx, text22, x22, y22, fontsize2);
				
				var text23 = "構わないよ";
				var x23 = x22 - (fontsize2 + margin);
				var y23 = y22;
				tategaki(ctx, text23, x23, y23, fontsize2);

				//画像の保存
				var out, stream;
				out = fs.createWriteStream(__dirname + '../tmp/tmpYasuna.png');
				stream = canvas.pngStream();
				stream.on('data', function(chunk) {
					out.write(chunk);
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
			context.font = 'bold' + fontsize + 'px sans-serif';
			if(ch == "っ")
				context.fillText(ch, x - lineHeight * i, y + lineHeight * (j - 1) + 5 * lineHeight / 6);
			else
				context.fillText(ch, x - lineHeight * i, y + lineHeight * j);
		});
	});
};


