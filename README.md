# gochiusa-bot

[![Travis](https://img.shields.io/travis/ryo-san470/gochiusa-bot.svg?style=flat-square)](https://travis-ci.org/ryo-san470/gochiusa-bot)
[![License](http://img.shields.io/:license-mit-blue.svg?style=flat-square)](http://jtwp470.mit-license.org/)

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

gochiusa-bot is "Is the order a rabbit?" BOT.

(Inspired by [Makibot](https://github.com/sanographix/makibot))

## Feature

* ごちうさというフレーズに反応してアニメ画像をランダムで吐きます.
  ![ごちうさというフレーズに反応する](./assets/gochiusa.png)
* chino / @chino でチノちゃんがランダムでつぶやきます.
  ![chinoとつぶやく](./assets/chino.png)
* `$`で囲まれた部分をLaTeXと認識して数式を画像化したものを返します.
  ![LaTeX画像化](./assets/latex.png)
* 麻雀点数計算機能
  * `3翻30符`とかで点数を返します. (Thanks to [@dorapon2000](https://github.com/dorapon2000))
  ![点数表示](./assets/mahjong-calc.png)
  * 麻雀役出力機能 (Thanks to [@index30](https://github.com/index30), [@sga0221](https://github.com/sga0221), [@ksepynoin](https://github.com/ksepynoin))
  ![麻雀役出力機能](./assets/mahjong.png)
* ごちうさ言語の利用 (詳細は`glang help`を参考のこと)
* マジカルシルクハットゲーム機能
  * 遊戯王の「マジカルシルクハット」を元にしたゲーム機能.マジカルシルクハットに隠れた「ブラック・マジシャン」を当てれば勝ち.
* 575通知機能
  * 発言した文章が575だった場合にadd-reactionしてくれる機能.
  
  ![575の文章にadd-reactionする](./assets/goshichigo.png)
* 折部やすな機能
  * 「見たら本当に絶対○○するよ！」「もし○○しなかったら木の下に埋めてもらっても構わないよ」ジェネレーター機能.

  ![ジェネレーターの出力例](./assets/viewyasuna.png)

## How to contribute

1. 本リポジトリを[フォーク(Fork)](https://github.com/ryo-san470/gochiusa-bot/fork)してください．
2. 重複するプルリクエストを作成しないために他のプルリクエストを確認しましょう．
3. 自分のリポジトリにプッシュし，プルリクエストを作成して下さい．このときCIを通過するコードを提出して下さい．

[Wiki](https://github.com/ryo-san470/gochiusa-bot/wiki)を参照すると役に立つ頃があるかもしれません．

### :warning: CAUTION
文法チェックを追加しました.CoffeeScriptが正しく書かれていないとエラーになります.(例えば2インデントのところを4インデントにしているなど)
この文法チェックを通過するコードのみしかプルリクエストを受け付けないので気をつけてください.

自分の環境で文法チェックをするときは`coffeelint`や`npm test`などを使ってみてください.

#### JavaScriptにも文法チェックを追加しました
JavaScriptにも文法チェックを追加しました.
チェックには[ESLint](http://eslint.org/)を使っています.
これ以降, JavaScriptによるコードの追加にはこのテストに通過する必要があります.
コーディングスタイルについては[Google JavaScript Style Guide](https://google.github.io/styleguide/javascriptguide.xml)を参考にしています.
例外的なコーディングスタイルの許可については[.eslintrc.json](./.eslintrc.json)に書かれているのでそちらを参照してください.

## Contributors

* @dorapon2000
    * [点数計算機能の追加](https://github.com/jtwp470/gochiusa-bot/pull/13)
* @index30, @sga0221, @ksepynoin
    * [麻雀役を出力する機能の追加](https://github.com/jtwp470/gochiusa-bot/issues/14)
    * [麻雀役を出力する機能のソースコード改善](https://github.com/jtwp470/gochiusa-bot/issues/21)
* @sga0221
    * [マジカルシルクハットゲーム機能の追加](https://github.com/jtwp470/gochiusa-bot/pull/62)
    * [575の文章にadd-reactionする](https://github.com/jtwp470/gochiusa-bot/pull/74)
    * [折部やすなジェネレーター](https://github.com/jtwp470/gochiusa-bot/pull/77)

## License
The MIT License (MIT)

Copyright (c) 2015 - 2017 jtwp470

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
