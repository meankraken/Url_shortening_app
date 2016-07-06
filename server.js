'use strict';

global.jQuery = require('jquery');
var jquery = require('jquery');
var express = require('express');
var session = require('express-session');


var app = express();
require('dotenv').load();

var months = ["JANUARY","FEBRUARY","MARCH","APRIL","MAY","JUNE","JULY","AUGUST","SEPTEMBER","OCTOBER","NOVEMBER","DECEMBER"];


var path = process.cwd();



app.use('/common', express.static(process.cwd() + '/app/common'));
app.use('/public', express.static(process.cwd() + '/public'));

app.get('/',function(req,res,next) {
	res.sendFile(path + "/public/index.html");

});

app.get('/:id',function(req,res) {
	var isDate = false;
	var date = req.params.id; 
	var month = "";
	var year = 0;
	var day = 0;
	var dateStr = "";
	for (var i=0; i<months.length; i++) {
		if (date.toUpperCase().includes(months[i])) {
			isDate = true;
			var arr = months[i].toLowerCase().split("");
			arr[0] = arr[0].toUpperCase();
			month = arr.join("");
		}
	}
	if (isDate) {
		if (date.match(/(\d)+/g)) {
			var nums = date.match(/(\d)+/g);
			if (nums.length<2) {
				isDate = false;
			}
			else {
				var num1 = parseInt(nums[0]);
				var num2 = parseInt(nums[1]);
				if (num1 < num2) {
					day = num1;
					year = num2;
				}
				else {
					day = num2;
					year = num1;
				}
				if (day<=31) {
				dateStr = month + " " + day + ", " + year;
				var dateVar = new Date(dateStr);
				var reply = { 
					unix: dateVar.getTime()/1000,
					natural: dateStr 
				};
				res.send(reply);
				}
				else {
					isDate = false;
				}
			}
		
		}
		else {
			isDate = false;
		}
		
	}
	if (!isDate) {
		res.send("Please enter a valid date - include the month, day, and year.");
	}
	
	
	
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