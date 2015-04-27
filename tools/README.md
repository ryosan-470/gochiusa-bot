# naver_scraping.py

[毎週更新,525枚 ご注文はうさぎですか 画像壁紙キャプチャ](http://matome.naver.jp/odai/2139011062397372501?page=1)内にあるごちうさ関連用の画像のURLをスクレイピングするためだけのスクリプト

もう少し頑張ってnaverまとめにまとめられている画像URLをスクレイピングできるようになれば利用範囲が広がりそうでべんりそうです.

## 仕組み
まずPythonでスクレイピングするためにBeautifulSoupをつかっています.詳しくは[日本語ドキュメント](http://kondou.com/BS4/)を読むと良いでしょう.

調べて見てわかったのはURLが構造的に`http://matome.naver.jp/odai/{数字}`となっています.個々を始点として更に`http://matome.naver.jp/odai/{数字}/{各画像リンク}`となっていてその中に`http://imgcc.`で始まるような画像がリンクされています.

したがって各ページをスクレイピングしてまず`http://matome.naver.jp/odai/{数字}`内の`http://matome.naver.jp/odai/{数字}/{各画像リンク}`を片っ端からリストにぶち込みそのあとで画像ページをスクレイピングして画像本体へのリンクを得ています.


## TODO
* [ ] コマンドラインオプションでURLや保存先などを選択できるようにする
* [ ] CoffeeScriptで抽出した画像URLが保存されたテキストを読む


## License
MIT License
