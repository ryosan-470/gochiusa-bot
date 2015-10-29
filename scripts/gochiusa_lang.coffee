# Description:
#    ごちうさ言語
#    Brainfuck の派生言語
#
# Commands:
#    :glang run <gochiusa lang>  - eval your input code
#    :glang help                 - help view and show instruction codes
#    :glang sample               - run sample code randomize
module.exports = (robot) ->
  robot.hear /glang run( +(.*))?/i, (msg) ->
    code = msg.match[2]
    msg.send(run(parser(code)))

  robot.hear /glang help/i, (msg) ->
    help_text =
    ":glang run <gochiusa lang>  - eval your input code\n" +
    ":glang help                 - help view and show instruction codes\n" +
    ":glang sample               - run sample code\n" +
    "\n" +
    "<ごちうさ 命令コード 一覧>\n" +
    " こころ             - ポインタをインクリメントする\n" +
    " いつも             - ポインタをデクリメントする\n" +
    " ぴょん             - ポインタが指す値をインクリメント\n" +
    " らんらん           - ポインタが指す値をデクリメント\n" +
    " 待ち?              - 入力を受け付ける (NOT SUPPORTED)\n" +
    " はじめがかんじん   - ポインタが指す値が0なら対応する'つーんだつーんだ'までジャンプする\n" +
    " つーんだつーんだ   - ポインタが指す値が0でなければ対応する'はじめがかんじん'にジャンプする\n" +
    "\n" +
    "言語の更なる仕様やコードの説明に関してはhttps://github.com/jtwp470/gochiusa-bot/issues/43 が詳しい"
    msg.send help_text
  robot.hear /glang sample/i, (msg) ->
    sample = "Hello, World! を出力するごちうさ言語の例:\n" +
    "ぴょんぴょんぴょんぴょんぴょんぴょんぴょんぴょんぴょんはじめがかんじんこころぴょんぴょんぴょんぴょんぴょんぴょんぴょんぴょんこころぴょんぴょんぴょんぴょんぴょんぴょんぴょんぴょんぴょんぴょんぴょんこころぴょんぴょんぴょんぴょんぴょんいつもいつもいつもらんらんつーんだつーんだこころ言いなさいっこころぴょんぴょん言いなさいっぴょんぴょんぴょんぴょんぴょんぴょんぴょん言いなさいっ言いなさいっぴょんぴょんぴょん言いなさいっこころらんらん言いなさいっらんらんらんらんらんらんらんらんらんらんらんらんらんらんらんらんらんらんらんらんらんらんらんらん言いなさいっいつもぴょんぴょんぴょんぴょんぴょんぴょんぴょんぴょん言いなさいっらんらんらんらんらんらんらんらんらんらんらんらんらんらんらんらん言いなさいっぴょんぴょんぴょん言いなさいっらんらんらんらんらんらんらんらんらんらんらんらん言いなさいっらんらんらんらんらんらんらんらんらんらんらんらんらんらんらんらん言いなさいっこころぴょん言いなさいっ"
    msg.send sample


glang_commands = {
  "inc_ptr": "こころ",
  "dec_ptr": "いつも",
  "inc_byt": "ぴょん",
  "dec_byt": "らんらん",
  "output": "言いなさいっ",
  "input": "待ち?",
  "loop_start": "はじめがかんじん",
  "loop_end": "つーんだつーんだ"
}

bf_commands = {
  "inc_ptr": ">",
  "dec_ptr": "<",
  "inc_byt": "+",
  "dec_byt": "-",
  "output": ".",
  "input": ",",
  "loop_start": "[",
  "loop_end": "]"
}


# ごちうさ言語を内部表現に変換
parser = (g_code) ->
  for key of bf_commands
    bf_code = g_code.replace(///#{glang_commands[key]}///g, bf_commands[key])
    g_code = bf_code
  return bf_code


# bfインタープリタ
run = (code) ->
  pc = 0
  ptr = 0
  mem = (0 for k in [0...100000])
  printer = ""
  while pc < code.length
    if code[pc] is bf_commands["output"]
      printer += String.fromCharCode(mem[ptr])
    else if code[pc] is bf_commands["inc_byt"]
      mem[ptr] += 1
    else if code[pc] is bf_commands["dec_byt"]
      mem[ptr] -= 1
    else if code[pc] is bf_commands["inc_ptr"]
      ptr += 1
    else if code[pc] is bf_commands["dec_ptr"]
      ptr -= 1
    else if code[pc] is bf_commands["loop_start"]
      if mem[ptr] == 0
        nest = 0
        while true
          pc += 1
          if code[pc] is bf_commands["loop_end"] and nest == 0
            break
          if code[pc] is bf_commands["loop_start"]
            nest += 1
          if code[pc] is bf_commands["loop_end"]
            nest -= 1
    else if code[pc] is bf_commands["loop_end"]
      if mem[ptr] != 0
        nest = 0
        while true
          pc -= 1
          if code[pc] == bf_commands["loop_start"] and nest == 0
            break
          if code[pc] == bf_commands["loop_start"]
            nest -= 1
          if code[pc] == bf_commands["loop_end"]
            nest += 1
    pc += 1
  return printer

# console.log(run("++++++++[>++++[>++>+++>+++>+<<<<-]>+>+>->>+[<]<-]>>.>---.+++++++..+++.>>.<-.<.+++.------.--------.>>+.>++."))

# console.log(parser("ぴょんぴょんぴょんぴょんぴょんぴょんぴょんぴょんぴょんはじめがかんじんこころぴょんぴょんぴょんぴょんぴょんぴょんぴょんぴょんこころぴょんぴょんぴょんぴょんぴょんぴょんぴょんぴょんぴょんぴょんぴょんこころぴょんぴょんぴょんぴょんぴょんいつもいつもいつもらんらんつーんだつーんだこころ言いなさいっこころぴょんぴょん言いなさいっぴょんぴょんぴょんぴょんぴょんぴょんぴょん言いなさいっ言いなさいっぴょんぴょんぴょん言いなさいっこころらんらん言いなさいっらんらんらんらんらんらんらんらんらんらんらんらんらんらんらんらんらんらんらんらんらんらんらんらん言いなさいっいつもぴょんぴょんぴょんぴょんぴょんぴょんぴょんぴょん言いなさいっらんらんらんらんらんらんらんらんらんらんらんらんらんらんらんらん言いなさいっぴょんぴょんぴょん言いなさいっらんらんらんらんらんらんらんらんらんらんらんらん言いなさいっらんらんらんらんらんらんらんらんらんらんらんらんらんらんらんらん言いなさいっこころぴょん言いなさいっ"))
