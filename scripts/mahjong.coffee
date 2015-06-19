# Description:
#  麻雀
#
# Commands:
#    :mahjong / 麻雀  という言葉に反応して役を返します.
#    :%d翻%d符 /  という言葉で得点計算をします
#
# Documentation:
#  麻雀の役を登録するルールとして雀頭が予め登録してあり面子4つと組み合わせて出力することにします.
#  きちんと考えて書かないと字牌が5個とか出てしまうので考えてかいてください. (特に順子を追加するとき)
#

jhands1 = [":hai-ton:",":hai-sha:",":hai-nan:",":hai-pei:",":hai-hatsu:",":hai-chun:",":hai-haku:",]

hands1 = [[":1man:", ":2man:", ":3man:", ":4man:", ":5man:", ":6man:", ":7man:", ":8man:", ":9man:",],
[":1so:",":2so:",":3so:",":4so:",":5so:",":6so:",":7so:",":8so:",":9so:",],
[":1pin:",":2pin:",":3pin:",":4pin:",":5pin:",":6pin:",":7pin:",":8pin:",":9pin:"],]




# 10の位を切り上げ
carry10 = (num) ->
  Math.ceil(num / 100) * 100 # 小数にしてから小数点以下を切り捨てる

# 1の位を切り上げ
carry1 = (num) ->
  Math.ceil(num / 10) * 10   # 小数にしてから小数点以下を切り捨てる

module.exports = (robot) ->
  robot.hear /mahjong|麻雀|マージャン|まーじゃん/, (msg) ->
    kaze = (n1,n2) ->
        if n1 < 5
                msg.send "場風:北"
        else if 5 <= n1 < 20
                msg.send "場風:西"
        else if 20 <= n1 < 40
                msg.send "場風:南"
        else msg.send "場風:東"
        switch n2
                when 1 then msg.send "自風:東"
                when 2 then msg.send "自風:南"
                when 3 then msg.send "自風:北"
                else msg.send "自風:西"
    # 牌のカウント
    jhcount = [0,0,0,0,0,0,0]
    hcount = [[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]]
    #チートイ用カウント
    tijhcount = [0,0,0,0,0,0,0]
    tihcount = [[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]]

    # ドラ設定
    dorandam = Math.floor(Math.random()*4)+1
    if dorandam == 1
            doj = Math.floor(Math.random()*7)+1
            dojh = doj-1
            jhcount[dojh] = jhcount[dojh]+1
            tijhcount[dojh] = tijhcount[dojh]+1
            msg.send "ドラ表示牌:#{jhands1[dojh]}"
    else
            dom = Math.floor(Math.random()*3)+1
            domsp = dom-1
            dora = Math.floor(Math.random()*9)+1
            doh = dora-1
            hcount[domsp][doh] = hcount[domsp][doh]+1
            tihcount[domsp][doh] = tihcount[domsp][doh]+1
            msg.send "ドラ表示牌:#{hands1[domsp][doh]}"
    # 雀頭生成
    # 雀頭選択用乱数生成1(字牌か数牌か)
    headra = Math.floor(Math.random() * 4)+1
    # 雀頭選択用乱数生成2(字牌を選んだ場合)
    headrb = Math.floor(Math.random() * 7)+1
    # 雀頭選択用乱数生成3(数牌を選んだ場合)
    headrc = Math.floor(Math.random() * 9)+1
    hb = headrb-1
    hc = headrc-1
    count = 1
    #検証用
    headra1 = 2
    if headra1 == 1
        loop
                hbodyrb = Math.floor(Math.random() * 7)+1
                heb = hbodyrb-1
                break unless jhcount[heb] >= 3
        head1 = jhands1[heb].concat(jhands1[heb])
        jhcount[heb] = jhcount[heb]+2
        tijhcount[heb] = tijhcount[heb]+3
    else
        hms = Math.floor(Math.random()*3)+1
        hmsp = hms-1
        loop
                hbodyrc = Math.floor(Math.random() * 9)+1
                hc = hbodyrc-1
                break unless hcount[hmsp][hc] >= 3
        head1 = hands1[hmsp][hc].concat(hands1[hmsp][hc])
        #head1 = hands1[1][8].concat(hands1[1][8])
        hcount[hmsp][hc] = hcount[hmsp][hc]+2
        tihcount[hmsp][hc] = tihcount[hmsp][hc]+3
    #雀頭の確認
    #msg.send "雀頭字牌"
    #msg.send "東,西,南,北,發,中,白"
    #msg.send "#{jhcount}"
    #msg.send "雀頭数牌"
    #msg.send "#{hcount[0]}"
    #msg.send "#{hcount[1]}"
    #msg.send "#{hcount[2]}"
    # 場風、自風の設定(関数呼び出し)
    bakaze = Math.floor(Math.random() * 100)+1
    mykaze = Math.floor(Math.random() * 4)+1
    kaze.call(null,bakaze,mykaze)

    # makebody!
    # body!
    body = []
    finalbody = []
    # 順子にするのか刻子にするのかの乱数生成
    # 字牌の場合の乱数生成
    # bodyrb = Math.floor(Math.random() * 7)+1
    # 数牌の場合の乱数生成
    bodyrc = Math.floor(Math.random() * 9)+1
    bb = bodyrb-1
    bc = bodyrc-1
    count = [0,0,0,0,0]

    for i in [0..3]
        j = 5
        j = j - i
        sork = Math.floor(Math.random() * 2)+1
        #検証用:生成するのを刻子に固定
        sork1 = 1
        na = Math.floor(Math.random()*5)+1
        naki = na-1
        # 乱数の生成(字牌にするか数牌にするか)
        bodyra = Math.floor(Math.random() * 4)+1
        switch sork
                # 刻子の場合
                when 1
                    ms = Math.floor(Math.random()*3)+1
                    msp = ms-1
                    #msp = 1
                    if bodyra == 1
                        loop
                                bodyrb = Math.floor(Math.random() * 7)+1
                                bb = bodyrb-1
                                break unless jhcount[bb] >= 2

                        jhcount[bb] = jhcount[bb]+3
                        if naki != 4
                                hand2 = ((["("].concat(jhands1[bb])).join("")).concat(jhands1[bb].concat(jhands1[bb].concat([")"])))
                        else
                                hand2 = jhands1[bb].concat(jhands1[bb].concat(jhands1[bb]))
                        body = body.concat(hand2)
                    else
                        loop
                                bodyrb = Math.floor(Math.random() * 9)+1
                                bb = bodyrb-1
                                break unless hcount[msp][bb] >= 2
                        hcount[msp][bb] = hcount[msp][bb]+3
                        if naki == 1 || naki == 2
                                hand2 = ((["("].concat(hands1[msp][bb])).join("")).concat(hands1[msp][bb].concat(hands1[msp][bb].concat([")"])))
                        else
                                hand2 = hands1[msp][bb].concat(hands1[msp][bb].concat(hands1[msp][bb]))
                        body = body.concat(hand2)
                # 順子の場合
                else
                    ms1 = Math.floor(Math.random()*3)+1
                    msp1 = ms1-1
                    loop
                        # 選択した牌の番号
                        tbodyrb = Math.floor(Math.random() * 7)+1
                        # 選択した牌の一つ前の牌の番号
                        tbb = tbodyrb-1
                        # 選択した牌の一つ後の牌の番号
                        tbb1 = tbodyrb+1
                        break unless hcount[msp1][tbodyrb] >= 4 || hcount[msp1][tbb] >= 4 || hcount[msp1][tbb1] >= 4
                    hcount[msp1][tbodyrb] = hcount[msp1][tbodyrb]+1
                    hcount[msp1][tbb] = hcount[msp1][tbb]+1
                    hcount[msp1][tbb1] = hcount[msp1][tbb1]+1
                    if naki == 1
                        hand2 = ((["("].concat(hands1[msp1][tbb])).join("")).concat(hands1[msp1][tbodyrb].concat(hands1[msp1][tbb1].concat([")"])))
                    else
                        hand2 = hands1[msp1][tbb].concat(hands1[msp1][tbodyrb].concat(hands1[msp1][tbb1]))
                    body = body.concat(hand2)
    #検証用コメント
    #msg.send "字牌"
    #msg.send "#{jhcount}"
    #msg.send "数牌"
    #msg.send "#{hcount[0]}"
    #msg.send "#{hcount[1]}"
    #msg.send "#{hcount[2]}"

    b1 = body.shift()# i = 3
    b2 = body.shift()# i = 2
    b3 = body.shift()# i = 1
    b4 = body.shift()# i = 0
    #msg.send "#{head1} #{b1} #{b2} #{b3} #{b4}"
    #チートイ錬成
    tibody = []

    for k in [0..5]
        theadra = Math.floor(Math.random() * 4)+1
        if theadra == 1
                loop
                        hbodyrb = Math.floor(Math.random() * 7)+1
                        heb = hbodyrb-1
                        break unless tijhcount[heb] >= 2
                tihead1 = jhands1[heb].concat(jhands1[heb])
                tijhcount[heb] = tijhcount[heb]+2
                tibody = tibody.concat(tihead1)
        else
                hms = Math.floor(Math.random()*3)+1
                hmsp = hms-1
                loop
                        hbodyrc = Math.floor(Math.random() * 9)+1
                        hc = hbodyrc-1
                        break unless tihcount[hmsp][hc] >= 2
                tihead1 = hands1[hmsp][hc].concat(hands1[hmsp][hc])
                tihcount[hmsp][hc] = tihcount[hmsp][hc]+2
                tibody = tibody.concat(tihead1)

    tirandom = Math.floor(Math.random()*20)+1
    #tirandom = 7
    tb1 = tibody.shift()
    tb2 = tibody.shift()
    tb3 = tibody.shift()
    tb4 = tibody.shift()
    tb5 = tibody.shift()
    tb6 = tibody.shift()

    #国士実装
    kokusirandom = Math.floor(Math.random()*15)+1
    #kokusirandom = 13
    kokusibody  = ":1man::9man::1so::9so::1pin::9pin::hai-ton::hai-nan::hai-sha::hai-pei::hai-haku::hai-hatsu::hai-chun:"
    kokushijork = Math.floor(Math.random()*2)+1
    if kokushijork == 1
            kr = Math.floor(Math.random()*3)+1
            kor = kr-1
            khai = Math.floor(Math.random()*2)+1
            if khai == 1
                    kokusipin = hands1[kor][0]
            else
                    kokusipin = hands1[kor][8]
    else
            jkr = Math.floor(Math.random()*7)+1
            jikor = jkr-1
            kokusipin = jhands1[jikor]


    if tirandom == 7 || tirandom == 14
            if kokusirandom == 13
                    msg.send "#{kokusibody} #{kokusipin}"
            else
                    msg.send "#{head1} #{tb1} #{tb2} #{tb3} #{tb4} #{tb5} #{tb6}"
    else
        msg.send "#{head1} #{b1} #{b2} #{b3} #{b4}"

  robot.hear /(\d+)(翻|飜)(\d+)符/, (msg) ->
    han = parseInt(msg.match[1], 10)
    hu = parseInt(msg.match[3], 10)
    if (hu <= 10 and 110 < hu) or (han == 1 and hu <= 20) or han < 1
      msg.send "404 Not Found"
      return

    hu = carry1(hu) if hu != 25
    parent_ron = 0
    parent_tumo = 0
    children_ron = 0
    children_tumo4parent = 0
    children_tumo4children = 0

    if 1 <= han <= 4
        basic_point = hu * (2 ** (han + 2))
        if basic_point > 2000 then basic_point = 2000
        children_tumo4children = carry10(basic_point * 1)
        children_tumo4parent = carry10(basic_point * 2)
        children_ron = carry10(basic_point * 4)
        parent_tumo  = carry10(basic_point * 2)
        parent_ron = carry10(basic_point * 6)
    else if 5 <= han
        switch han
          when 5 then children_ron = 8000
          when 6, 7 then children_ron = 12000
          when 8, 9, 10 then children_ron = 16000
          when 11, 12 then children_ron = 24000
          when 13 then children_ron = 32000
          else children_ron = 32000
        children_tumo4parent = children_ron / 2
        children_tumo4children = children_ron / 4
        parent_ron = children_ron * 1.5
        parent_tumo = parent_ron / 3

    parent_ron = parent_ron.toString()
    parent_tumo = parent_tumo.toString()
    children_ron = children_ron.toString()
    children_tumo4parent = children_tumo4parent.toString()
    children_tumo4children = children_tumo4children.toString()
    msg.send """ロン：親は #{parent_ron} 点です
                      子は #{children_ron} 点です
                ツモ：親は #{parent_tumo} オールです
                      子は (#{parent_tumo} ,#{children_tumo4children}) です
             """

