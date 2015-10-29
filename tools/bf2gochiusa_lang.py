#!/usr/bin/env python3
# -*- coding: utf-8 -*
# brainfuck commands
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

gochiusa_lang_commands = {
    "inc_ptr": "こころ",
    "dec_ptr": "いつも",
    "inc_byt": "ぴょん",
    "dec_byt": "らんらん",
    "output": "言いなさいっ",
    "input": "待ち?",
    "loop_start": "はじめがかんじん",
    "loop_end": "つーんだつーんだ"
}


def convert(bf_code):
    for key in bf_commands.keys():
        bf_code = bf_code.replace(bf_commands[key], gochiusa_lang_commands[key])
    return bf_code


if __name__ == "__main__":
    import sys
    if len(sys.argv) == 2:
        with open(sys.argv[1]) as f:
            c = f.read().split("\n")
            code = ""
            for k in c:
                code += k.strip()
            print(code)
            print(convert(code))
    else:
        while True:
            inp = input(">> ")
            if inp == "end":
                break
            print("<< " + convert(inp))
