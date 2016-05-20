// Description:
//   文章が575の場合、教えてくれます。
//
// Commands:
//  hubot > 任意の575の文字列 
//  hubot > add-reaction :goshichigo:
//


(function(){
	var url = "https://labs.goo.ne.jp/api/morph";
	var app_ID = process.env.GOO_APP_ID;
	if (!app_ID){
		console.error("error: Set your GOO_APP_ID env variables.");
	}
	module.exports=function(robot){	    
		//入力された文章の取得
		return robot.hear(/.*/i,function(msg){
			//APIに渡すためのデータ
			var data;
			data = JSON.stringify({
				"app_id" : app_ID,
				"sentence" : msg.match[0]	
			});
			return robot.http(url).header("Content-type","application/json").post(data)(function(err, res, body){
				var result = JSON.parse(body);
				var sentence = result.word_list;
				if(is575(sentence))
					return addReactions(msg,"goshichigo");
				
			});    
		});
	};
}).call(this);

//575か判定するメソッド
function is575(sentence){
	var count = [0,0,0];
	var count_lim = [5,7,5];
	var now_watch = 0;
	for(i in sentence){ //行
		for(j in sentence[i]){ //列
			var word = sentence[i][j];
			if(word[2] == "＄")  //読めない文字は無視
				continue;

			//575達成後に読める文字が存在してしまう場合
			if(now_watch > 2)
				return false;
			
			var is_joshi = (word[1].indexOf("助") != -1); //助詞の判定
			var is_hanteishi = (word[1].indexOf("判") != -1); //判定詞の判定

			//575の最初が助詞、判定詞になってしまう場合、falseを返す
			if((is_joshi || is_hanteishi) && count[now_watch] == 0)
				return false;
			
			var wordReading = word[2].replace(/ャ|ュ|ョ|ァ|ィ|ゥ|ェ|ォ/g, ""); //小さい文字の削除
			count[now_watch] += wordReading.length;
			
			//文字数の判定
			if(count[now_watch] > count_lim[now_watch]){
				return false;
			}else if(count[now_watch] == count_lim[now_watch]){
				now_watch++;
			}
		}
	}
	if(now_watch == 3)
		return true;
	else
		return false;	
}



/*
add-reactionするメソッド
参考記事：
HubotでSlackのEmoji Reactionを付ける
http://qiita.com/hiconyan/items/f2c37a10ac2c581693ce
*/
var request = require('request');

var addReactions = function(msg, name){
	var options;
	options = {
		url: 'https://slack.com/api/reactions.add',
		qs: {
			'token': process.env.HUBOT_SLACK_TOKEN,
			'name': name,
			'channel': msg.message.rawMessage.channel,
			'timestamp': msg.message.rawMessage.ts
		}
	};
	return request.post(options, function(err, res, body) {
		if ((err != null) || res.statusCode !== 200) {
			return robot.logger.error("Failed to add emoji reaction " + (JSON.stringify(err)));
		}
	});
};
