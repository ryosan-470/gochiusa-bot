var querystring = require('querystring');
var fs = require('fs');
var path = require('path');

module.exports = function(robot) {
  return robot.router.get("/hubot/viewyasuna.png", function(req, res) {
    var query = querystring.parse(req._parsedUrl.query);
    var tmp = path.join(__dirname, '..', 'tmp', query.id);
    return fs.readFile(tmp, function(err, data) {
      res.writeHead(200, {
        'Content-Type': 'image/png'
      });
      return res.end(data);
    });
  });
};
