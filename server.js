'use strict';

global.jQuery = require('jquery');
var jquery = require('jquery');
var express = require('express');
var session = require('express-session');
var os = require('os');

var app = express();
require('dotenv').load();



var path = process.cwd();



app.use('/common', express.static(process.cwd() + '/app/common'));
app.use('/public', express.static(process.cwd() + '/public'));

app.get('/',function(req,res,next) {
	var ip = req.headers['x-forwarded-for'];
	var lang = req.headers["accept-language"];
	var opSys = os.release().toString() + " " + os.hostname().toString() + " " + os.platform().toString() + " " + os.arch().toString();
	var retObj = { 
		ip: ip, 
		language: lang,
		OS: opSys
	};
	res.write(JSON.stringify(retObj));
	res.end();
	
});



app.use(session({
	secret: 'secretClementine',
	resave: false,
	saveUninitialized: true
}));



var port = process.env.PORT || 8080;
app.listen(port,  function () {
	console.log('Node.js listening on port ' + port + '...');
});