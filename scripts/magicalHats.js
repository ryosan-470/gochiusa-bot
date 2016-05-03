// Description:
//   マジカルシルクハットゲームをします。
//   〜例〜
//   hubot > start magical
//   hubot > :magical: :magical: :magical: :magical: 
//   hubot > magical 2
//   hubot > :magical: :bramagi: :magical: :magical:
//   
// Commands:
//   start magical - ゲームの開始
//   magical \d - 左から\d番目のマジカルシルクハットを攻撃します

//robot.brainのkey
var BRAIN_KEY = "magicalHats"; 
//カードの名前（sukaは空を意味します)
var cardList =
	    [":bramazi:",
	     ":rokubousei:",
	     ":magiccylinder:",
	     ":suka:",
	     ":suka:",
	     ":suka:",
	     ":suka:"];


(function(){
	module.exports=function(robot){	    
		//magical start
		robot.hear(/start(\s*)magical/i,function(msg){
			var checkenv = robot.brain.get(BRAIN_KEY);
			if(checkenv != null){
				var ans = "遊戯「勝負はまだ終わってないぜ！」";
				var strMagical = printMagicalHuts(checkenv.list);
				var strPoint = printLifePoint(checkenv.point);
				return msg.send(ans + "\n" + strMagical + "\n" + strPoint);
			}

			var list = setMagicalList();
			var point = getRandomInt(1,3);
			var env = new magiEnv(list,point);

			robot.brain.set(BRAIN_KEY , env);
			robot.brain.save();

			var strPoint = printLifePoint(point);
			var ans = "遊戯「魔法カード、マジカルシルクハット発動！」";
			var strMagical = printMagicalHuts(list);
			//出力
			return msg.send(strPoint + "\n" + ans + "\n" + strMagical);
		});
		
		//magical choice
		robot.hear(/magical(\s*)(\d+)/i,function(msg){
			var num = msg.match[2];
			var env = robot.brain.get(BRAIN_KEY);
			if(env == null){
				return msg.send("Please \"start magical\".");
			}
			if(num < 1 || num > 4){
				return msg.send("Please \"magical [1-4]\".");
			}

			env.point--; //攻撃権を一つ消費
			env.list[num - 1].isOpen = true; //指定のカードをOpen
			
			var ans1 = "海馬「滅びの爆裂疾風弾！」";
			var ans2;
			var strMagical = printMagicalHuts(env.list);
			var ans3;
			
			if(env.list[num - 1].isCorrect){ //ブラック・マジシャンを当てた場合の処理（勝利処理）	
				ans2 = "遊戯「うわあああああ！」";
				ans3 = "杏子「次回、『遊戯 死す』 デュエルスタンバイ！」";
				robot.brain.set(BRAIN_KEY, null); //終了処理
				return msg.send(ans1 + "\n" + strMagical + "\n" + ans2 + "\n" + ans3);
				
			}else if(env.list[num - 1].num == 1) { //六芒星の呪縛処理
				ans2 ="遊戯「罠カード発動！『六芒星の呪縛』！攻撃を封じると同時に、攻撃力を700下げる！」";
				env.point--; //攻撃権を一つ消費
				ans3 = printLifePoint(env.point);
				
			}else if(env.list[num - 1].num == 7){ //魔法の筒による敗北処理
				ans2 ="遊戯「罠カード発動！『魔法の筒』！」";
				ans3 = "海馬「うおおおおお！」\n" +
					"杏子「次回、『海馬 死す』 デュエルスタンバイ！」";
				robot.brain.set(BRAIN_KEY, null); //終了処理
				return msg.send(ans1 + "\n"  + strMagical + "\n" + ans2 + "\n"  + ans3);
				
			}else{ //その他（sukaのみ?)
				ans2 = "遊戯「ﾌｯ...」\n" +
					"海馬「外したか...」";
				ans3 = printLifePoint(env.point);
			}
			
			if(env.point <= 0){ //攻撃権がなくなった場合の処理（敗北処理）
				ans3 = "海馬「くっ... ターンエンドだ」\n" + 
					"遊戯「いくぜ、俺のターン！ブラックマジック！」\n" +
					"海馬「うおおおおお！」\n" +
					"杏子「次回、『海馬 死す』 デュエルスタンバイ！」";
				robot.brain.set(BRAIN_KEY, null); //終了処理
			}
			
			return msg.send(ans1 + "\n" + ans2 + "\n" + strMagical + "\n" + ans3);
			
		});
	};
	
}).call(this);

//環境を保存する構造体
function magiEnv(magiList,lifePoint){
	this.list = magiList;
	this.point = lifePoint;
}
//マジカルシルクハットの構造体
function magicalHut(cardNum,isCorrect){
	this.num = cardNum;
	this.name = cardList[cardNum];
	this.isCorrect =  isCorrect;
	this.isOpen = false;
}

//ライフポイント表示の生成メソッド
function printLifePoint(point){
	var ans = "攻撃できるブルーアイズ： ";
	for(var i = 0; i < point; i++)
		ans += ":blueeyes:";
	return ans;
}

//マジカルシルクハット表示の生成メソッド
function printMagicalHuts(magiList){
	var ans = "";
	for(var i = 0; i < magiList.length; i++){
		if(magiList[i].isOpen)
			ans += magiList[i].name + " ";
		else
			ans += ":magical: ";
	}
	return ans;
}

//マジカルシルクハットの生成
function setMagicalList(){
	var magicalList = [null,null,null,null]; //magicalListの生成
	var trueIndex = getRandomInt(0,3); //当たりカードの場所

	for(var i = 0; i < magicalList.length; i++){
		if(i == trueIndex)
			magicalList[i] = new magicalHut(0, true);
		else
			magicalList[i] = new magicalHut(getRandomInt(1,cardList.length-1), false);						  
	}
	
	return magicalList;
}

//乱数
function getRandomInt(min, max) {
	return Math.floor( Math.random() * (max - min + 1) ) + min;
}
