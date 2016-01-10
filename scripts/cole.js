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
		return robot.hear(/say(\s*)cole(\s*)(\S+)/i,function(msg){
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
	var last_word = sentence[sentence.length - 1][sentence[0].length - 1];
	
	var meishi_last = false;
	
	for(i in sentence){
		for(j in sentence[i]){
			var tmp = sentence[i][j];
			
			if(tmp[2] !="＄"){ //読めない文字を削除		
				
				var is_joshi = tmp[1].indexOf("助"); //助詞の判定
				var is_hanteishi = tmp[1].indexOf("判"); //判定詞の判定
				var is_Meishi = tmp[1].indexOf("名詞"); //名詞、固有名詞判定
				var is_Keiyoushi = tmp[1].indexOf("形容詞");//形容詞の判定
				
				
				if(is_joshi != -1 || is_hanteishi != -1){
					joshi += tmp[2];
				}else{
					//名詞かどうか
					meishi_last = (is_Meishi != -1);
					
					ans += joshi + tmp[2];
					joshi = ""; //リセット
				}
				origin += tmp[0];
			}
		}
	}
	//語尾が名詞かどうか
	if(meishi_last){
		ans += "ダ";
	}
	//疑問文の判定
	if(last_word[0].indexOf("？") != -1 || last_word[0].indexOf("?") != -1){ 
		ans = "ソレハワカラナイ";
	}
	
	return [ans,origin];
}

//「〜ガ、」以降の部分の出力
function but_ans(ans1){
	var is_Hour = ans1.indexOf("時");
	var is_Min = ans1.indexOf("分");
	
	if(is_Hour != -1 || is_Min != -1){
		var jikan= new Date();
		
		//時・分・秒を取得する
		var hour = (jikan.getHours() + 24 - 14) % 24;
		var minute = jikan.getMinutes();
		
		return "カナダハイマ、" + hour + "時" + minute + "分デス。" ;
	}
	
	var sentence = [
		"ゴク小サイハンイデカンガエルトソウデハナイ.",
		"FDTDヲツカウコトデ、コノモンダイハトケマス.",
		"ソレハフクザツデアルトハイエナイ",
		"ソレハナニニテイルトオモイマスカ？",
		"シリョウハマダキテイナイ"
	];
	
	var num = getRandomInt(0, sentence.length - 1);
	
	return sentence[num];
}

//乱数
function getRandomInt(min, max) {
	return Math.floor( Math.random() * (max - min + 1) ) + min;
}
