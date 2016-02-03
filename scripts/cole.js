// Description:
//   文章を入力すると、cole風？に文章を返してくれます。
//   〜例1〜
//   hubot > cole 今日は寒い
//   hubot > キョウハサムイガ、hogehoge
//
//   〜例2〜
//   hubot > cole めっちゃ暇
//   hubot > メッチャヒマダガ、fugafuga
//
//   〜例3〜
//   hubot > cole 今何時？
//   hubot > ワカラナイガ、カナダハxx時yy分デス
//
//   〜例4〜
//   hubot > cole 今日の飯
//   hubot > キョウノメシダガ、「かつ大」ガイイトオモイマス。
//
// Commands:
//   cole 文章 - return ブンショウダガ、hogehoge
//   
//



(function(){
	var url = "https://labs.goo.ne.jp/api/morph";
	var app_ID = process.env.GOO_APP_ID;
	if (!app_ID){
		console.error("error: Set your GOO_APP_ID env variables.");
	}
	module.exports=function(robot){	    
		//入力された文章の取得
		return robot.hear(/say(\s*)cole(\s*)(\S.*)/i,function(msg){
			//APIに渡すためのデータ
			var data;
			data = JSON.stringify({
				"app_id" : app_ID,
				"sentence" : msg.match[3]	
			});
			return robot.http(url).header("Content-type","application/json").post(data)(function(err, res, body){
				var result = JSON.parse(body);
				var sentence = result.word_list;
				//入力文の解析
				var ans1 = jikukaiseki(sentence);
				//「〜ガ、」
				var but = "ガ、";
				//「〜ガ、」以降の部分の決定
				var ans2 = but_ans(ans1[1]); 
				//出力
				return msg.send(":cole: ＜" + ans1[0] + but + ans2);
			});    
		});
	};
}).call(this);

//入力文をカタカナに変換し、さらに「〜ガ」に繋ぎやすくする。
function jikukaiseki(sentence){
	var ans = "";
	var origin  = "";
	var joshi = "";
	var last_word = sentence[sentence.length - 1][sentence[sentence.length - 1].length - 1]; //最後の文字の取得
	var add_Da = false;
	
	for(i in sentence){
		for(j in sentence[i]){
			var tmp = sentence[i][j];
			
			//if(tmp[2] !="＄"){ //読めない文字を削除		
				
			var is_joshi = tmp[1].indexOf("助"); //助詞の判定
			var is_hanteishi = tmp[1].indexOf("判"); //判定詞の判定
			var is_Meishi = tmp[1].indexOf("名詞"); //名詞、固有名詞判定
			var is_Kana = tmp[1].indexOf("Kana"); //Kana（ただの仮名文字）の判定
			var is_Doku = tmp[1].indexOf("独"); //独立詞の判定
			
			var is_AlPhabet = (tmp[1] == "Alphabet" || tmp[1] == "Roman");//アルファベット(またはRoman)の判定
			
			
			if(tmp[2] == "＄"){ //読めない文字の場合
				joshi += " ";
			}else if(is_joshi != -1 || is_hanteishi != -1  || is_Kana != -1){ //助詞または判定詞、仮名文字の場合
				joshi += tmp[2];
			}else{  //それ以外
				
				//最後に処理した文字が名詞または独立詞、アルファベットかどうか
				add_Da = (is_Meishi != -1 || is_Doku != -1 || is_AlPhabet);
				
				//アルファベットの場合
				if(is_AlPhabet){
					ans += joshi + tmp[0];		
				}else{
					ans += joshi + tmp[2]; //今まで追加していた助詞、判定詞を追加
				}
				joshi = ""; //助詞、判定詞のリセット
				
			}
			origin += tmp[0];
		}
		//}
	}
	//「ダ」を追加
	if(add_Da){
		ans += "ダ";
	}
	//疑問文の判定
	if(last_word[0].indexOf("？") != -1 || last_word[0].indexOf("?") != -1){ 
		ans = "ワカラナイ"; //疑問文の場合、「ワカラナイガ〜」と答える
	}
	
	return [ans,origin];
}

//「〜ガ、」以降の部分の出力
function but_ans(ans1){
	//時間判定
	var is_Hour = ans1.indexOf("時");
	var is_Min = ans1.indexOf("分");

	//飯判定
	var is_Meshi = ans1.indexOf("飯");
	//１．飯判定
	if(is_Meshi != -1){
		var meshi = require("./data/meshi_shop.json");

		//選択するもののリストの作成（乱数）
		var num = [-1,-1,-1];
		for(var i = 0; i < 3; i++){
			while(true){
				var tmp = getRandomInt(0, meshi.length - 1);
				if(num.indexOf(tmp) == -1){
					num[i] = tmp;
					break;
				}
			}
		}
		return "「" + meshi[num[0]] + "」「" + meshi[num[1]] + "」「" + meshi[num[2]] + "」ガイイトオモイマス.";
		
	}
	
	//２．時間判定
	if(is_Hour != -1 || is_Min != -1){
		var jikan= new Date();
		
		//時・分・秒を取得する
		var hour = (jikan.getHours() + 24 - 14) % 24;
		var minute = jikan.getMinutes();
		
		return "カナダハイマ、" + hour + "時" + minute + "分デス。" ;
	}
	
	//３．その他
	var sentence = [
		"ゴク小サイハンイデカンガエルトソウデハナイ.",
		"FDTDヲツカウコトデ、コノモンダイハトケマス.",
		"ソレハフクザツデアルトハイエナイ",
		"ソレハナニニテイルトオモイマスカ？",
		"シリョウハマダキテイナイ",
		"ワタシノTAハカレーガダイスキデス",
		"...スイマセンカナダニイッテマシタ"
	];
	
	var num = getRandomInt(0, sentence.length - 1);
	
	return sentence[num];
}

//乱数
function getRandomInt(min, max) {
	return Math.floor( Math.random() * (max - min + 1) ) + min;
}
