# Description:
#   $$で囲まれたLaTeX形式の数式を返します
#
# Commands:
#    $LaTeXCode$ => LaTeX picture
module.exports = (robot) ->
  robot.hear /\$.+?\$/, (msg) ->
    msg.send "http://latex.codecogs.com/gif.latex?#{msg.match[0]}"
