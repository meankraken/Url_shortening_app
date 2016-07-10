'use strict';

global.jQuery = require('jquery');
var jquery = require('jquery');
var express = require('express');
var session = require('express-session');
var os = require('os');

var app = express();
require('dotenv').load();
var path = process.cwd();
var urls = [];
var index = 0;



app.use('/common', express.static(process.cwd() + '/app/common'));
app.use('/public', express.static(process.cwd() + '/public'));

app.get('/',function(req,res,next) {
	var url = req.query.url; 
	if (url) { 
		next();	
	}
	else {
		res.sendfile("./app/common/index.html");
	}
	
});

app.get('/', function(req,res,next) {
	var url = req.query.url; 
	if (url.match(/^http[s]?:\/\/.*(.com|.net|.org|.edu)\/?.*/gmi)) {
		urls.push(url);
		index++;
		res.end("Your shortened url is: " + req.protocol + "://" + req.host + "/" + index);
	}
	else {
		next();
	}
});

app.get('/', function(req,res) {
	res.end("Please enter a url with a valid protocol and extension.");	
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