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
var numDocs = 0;


app.use('/common', express.static(process.cwd() + '/app/common'));
app.use('/public', express.static(process.cwd() + '/public'));
app.use('/scripts', express.static(process.cwd() + '/node_modules'));

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
		MongoClient.connect(dbUrl, function(err, db) {
			if (err) {
				console.log(err);
			}	
			else {
			
				db.collection('urls').count({}, function(err,count) {
					if (err) {
						console.log(err);
					}	
					else {
						numDocs = count;
						console.log(count);
						addDoc(db, count, req, res);
					}
					
				});
				
				
				
			}
			
		
			
		});
		
	}
	else {
		next();
	}
});

function addDoc(db, count, req, res) {
	db.collection('urls').insert({ _id: count+1, url: req.query.url });
	db.close();
	res.end("Your shortened url is: " + req.protocol + "://" + req.host + "/" + parseInt(count+1));
}

app.get('/', function(req,res) {
	res.end("Please enter a url with a valid protocol and extension.\nExample: http://www.google.com" );	
});



app.get('/:id', function(req,res) {
	MongoClient.connect(dbUrl, function(err,db) {
		var num = req.param('id');
		var obj = { _id: parseInt(num) }; 
		if (err) {
			console.log(err);
		}
		else {
			db.collection('urls').find(obj).toArray(function(err, result) {
				if (err) {
					console.log("Failed to find shortened url");
				}
				if (result.length==0) {
					res.end("This index is not in the database.");
				}
				else {
					res.redirect(result[0].url);
				}
			});
			
			db.close();
		}
	})
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