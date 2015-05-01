#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# naver.jpをスクレイピングする
# TODO:コマンドラインオプションでいろいろ引き受ける感じにする
import json
import argparse
import urllib.error
from urllib.request import urlopen
from bs4 import BeautifulSoup


def write2json(output, in_data):
    """Convert Python list to json data

    Args:
        output: This is name of the json output file name.
        in_data: The source of Python list which is converted to json

    Returns:
        Nothing. But output json file.
    """
    print("Writeing " + output)
    with open(output, 'w') as f:
        json.dump(in_data, f, indent=4, sort_keys=True)


# NAVERまとめページをパース
def parse_naver(url):
    """NAVERまとめページをパース

    Args:
        url: url is string. Parse url and scraping.

    Return:
        Python list. 例えばパースしたurlのHTML内に存在する<a href=>で始まる
        URLを片っ端からリストに格納する.
    """
    href_list = list()
    print("Open..." + url)
    try:
        html = urlopen(url)
        soup = BeautifulSoup(html)
        for link in soup.find_all('a'):
            t = link.get('href')
            if t is not None:
                href_list.append(t)
    except urllib.error.URLError as e:
        print("Resource not found or other error")
        print("Detail:" + e)
    finally:
        return href_list


def main(max_page, base_url, output_json):
    href_list = list()
    for i in range(0, max_page):
        url = "{url}?page={num}".format(url=base_url, num=str(i))
        href_list.extend(parse_naver(url))
    href_list = list(filter(lambda x: (base_url in x), set(href_list)))
    print("Gathering {num} urls".format(num=str(len(href_list))))

    picture_list = list()
    for url in href_list:
        picture_list.extend(parse_naver(url))

    def isendsuffix(x):
        for i in [".jpg", ".png", ".gif"]:
            if x.endswith(i):
                return True
        return False

    l = []
    l.extend(list(filter(lambda x: isendsuffix(x), set(picture_list))))
    l = sorted(list(set(l)))
    write2json(output_json, l)


def parser_arguments():
    import sys
    parser = argparse.ArgumentParser(description="NAVERのまとめページをパースするよ")
    parser.add_argument("--maxpage", type=int, default=3,
                        help="パースするページの最大数")
    parser.add_argument("--out", type=str, default="test.json",
                        help="保存先とそのファイル名")
    parser.add_argument("--url", type=str,
                        help="スクレイピングするURL")
    args = parser.parse_args()
    if args.url is None:
        sys.exit("URLを指定してください")
    else:
        if "naver.jp" in args.url is False:
            sys.exit("対応外のページです")

    main(args.maxpage, args.url, args.out)


if __name__ == "__main__":
    parser_arguments()
    print("Finished")
