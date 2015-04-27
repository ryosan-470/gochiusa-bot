#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# naver.jpをスクレイピングする
# TODO:コマンドラインオプションでいろいろ引き受ける感じにする
from urllib.request import urlopen
from bs4 import BeautifulSoup

scrapping_url = 'http://matome.naver.jp/odai/2139011062397372501'

href_list = list() # 各画像へのリンクを格納するリスト
for i in range(1, 20):
    urls = "{url}?page={num}".format(url=scrapping_url, num=str(i))
    print("Open..." + urls)
    html = urlopen(urls)
    soup = BeautifulSoup(html)
    for link in soup.find_all('a'):
        t = link.get('href')
        if t is not None:
            href_list.append(t)

# セットにすれば重複なしになる
href_list = set(href_list)
href_list = list(filter(lambda x: (scrapping_url + "/") in x, href_list))

picture_list = list() # 画像のリンク (http://imgcc.で始まるURL)

for h in href_list:
    html2 = urlopen(h)
    soup2 = BeautifulSoup(html2)
    for link in soup2.find_all('a'):
        t = link.get('href')
        if t is not None:
            picture_list.append(t)

picture_list = set(picture_list)
print("抽出中")
picture_list = list(filter(lambda x: "http://imgcc." in x, picture_list))
with open('gochiusa_urls', 'w') as f:
    for p in picture_list:
        if p is not None:
            f.write("'" + p + "',\n")
