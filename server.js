'use strict';

global.jQuery = require('jquery');
var jquery = require('jquery');
var express = require('express');
var session = require('express-session');
var mongodb = require('mongodb');

var app = express();
var MongoClient = mongodb.MongoClient;

require('dotenv').load();
var path = process.cwd();
var urls = [];
var index = 0;
var dbUrl = "mongodb://localhost:27017/theBase";

MongoClient.connect(dbUrl, function(err, db) {
	if (err) {
		console.log("Error connecting to database:" + err);
	}
	else {
		var urlCollection = db.collection('urls');
		var doc = { data: "teh data", moreData: "mo data" };
		urlCollection.insert(doc, function(err, result) {
			if (err) {
				console.log(err);
			}
			else {
				console.log(result);
			}
		});
		db.close();
	}
	

});


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