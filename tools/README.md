# naver_scraping.py
これはNAVERによくあるアニメ系のまとめ画像ページ内を解析して画像のURLをjson形式で保存するスクリプトです.

そもそもは[毎週更新,525枚 ご注文はうさぎですか 画像壁紙キャプチャ](http://matome.naver.jp/odai/2139011062397372501)にある画像リンクのみが欲しかったのですが手作業では面倒だったのでスクレイピングするスクリプトを書きました.

## 必要なもの
動かすのに必要な物は以下のとおり.

* Python 3
* BeautifulSoup4
    * なお普通にpipで入れると3が入ってしまいます.きちんと`pip install beautifulsoup4`と指定しましょう.
## 使い方

```bash
$ python3 naver_scraping.py -h
usage: naver_scraping.py [-h] [--maxpage MAXPAGE] [--out OUT] [--url URL]

NAVERのまとめページをパースするよ

optional arguments:
-h, --help         show this help message and exit
--maxpage MAXPAGE  パースするページの最大数
--out OUT          保存先とそのファイル名
--url URL          スクレイピングするURL
```

URLは確実に指定しないと動きません.

```bash
$ python3 naver_scraping.py --url http://matome.naver.jp/odai/2139011062397372501/
```

## 仕組み
まずPythonでスクレイピングするためにBeautifulSoupをつかっています.詳しくは[日本語ドキュメント](http://kondou.com/BS4/)を読むと良いでしょう.

調べて見てわかったのはURLが構造的に`http://matome.naver.jp/odai/{数字}`となっています.個々を始点として更に`http://matome.naver.jp/odai/{数字}/{各画像リンク}`となっていてその中に`http://imgcc.`で始まるような画像がリンクされています.

したがって各ページをスクレイピングしてまず`http://matome.naver.jp/odai/{数字}`内の`http://matome.naver.jp/odai/{数字}/{各画像リンク}`を片っ端からリストにぶち込みそのあとで画像ページをスクレイピングして画像本体へのリンクを得ています.


## TODO
* [x] コマンドラインオプションでURLや保存先などを選択できるようにする
* [x] CoffeeScriptで抽出した画像URLが保存されたテキストを読む

## License
MIT License

# bf2gochiusa_lang.py
brainfuckのコードをごちうさ言語に変換するためのスクリプト.ただ置換しているだけなのでネット上にある適当なBrainfuckのソースコードをこのスクリプトに投げて変換した結果をBOTに投げれば(きちんと動くコードであれば)出力結果を返す.
