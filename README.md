# gochiusa-bot

[![Build Status](https://travis-ci.org/jtwp470/gochiusa-bot.svg)](https://travis-ci.org/jtwp470/gochiusa-bot)

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

gochiusa-bot is "Is the order a rabbit?" BOT.

(Inspired by [Makibot](https://github.com/sanographix/makibot))

## Feature

* ごちうさというフレーズに反応してアニメ画像をランダムで吐きます.
* chino / @chino でチノちゃんがランダムでつぶやきます.
* `$`で囲まれた部分をLaTeXと認識して数式を画像化したものを返します.
* 麻雀点数計算機能
    * `3翻30符`とかで点数を返します. (Thanks to @dorapon2000)

## 機能追加
基本的には`scripts/hoge.coffee`にCoffeeScriptで拡張機能を書きます.面白い機能やほしい機能があれば是非プルリクエストやIssueを立てていただけると幸いです.

## How to contribute

1. [Fork](https://github.com/jtwp470/gochiusa-bot/fork) this repository.
2. Check other pull request because we don't accept a redudant request.
3. Push and submit your pull request. (Please submit your code to accept CI test.)

Please refer to the [guide](https://github.com/jtwp470/gochiusa-bot/issues/12) of sending the pull request on GitHub. (Japanese)

## Contributors

* @dorapon2000
    * [点数計算機能の追加](https://github.com/jtwp470/gochiusa-bot/pull/13)

## License
The MIT License (MIT)

Copyright (c) 2015 jtwp470

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
