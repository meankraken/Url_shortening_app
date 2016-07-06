[1mdiff --git a/app/config/auth.js b/app/config/auth.js[m
[1mdeleted file mode 100644[m
[1mindex b8a43e9..0000000[m
[1m--- a/app/config/auth.js[m
[1m+++ /dev/null[m
[36m@@ -1,9 +0,0 @@[m
[31m-'use strict';[m
[31m-[m
[31m-module.exports = {[m
[31m-	'githubAuth': {[m
[31m-		'clientID': process.env.GITHUB_KEY,[m
[31m-		'clientSecret': process.env.GITHUB_SECRET,[m
[31m-		'callbackURL': process.env.APP_URL + 'auth/github/callback'[m
[31m-	}[m
[31m-};[m
[1mdiff --git a/app/config/passport.js b/app/config/passport.js[m
[1mdeleted file mode 100644[m
[1mindex bf39c15..0000000[m
[1m--- a/app/config/passport.js[m
[1m+++ /dev/null[m
[36m@@ -1,52 +0,0 @@[m
[31m-'use strict';[m
[31m-[m
[31m-var GitHubStrategy = require('passport-github').Strategy;[m
[31m-var User = require('../models/users');[m
[31m-var configAuth = require('./auth');[m
[31m-[m
[31m-module.exports = function (passport) {[m
[31m-	passport.serializeUser(function (user, done) {[m
[31m-		done(null, user.id);[m
[31m-	});[m
[31m-[m
[31m-	passport.deserializeUser(function (id, done) {[m
[31m-		User.findById(id, function (err, user) {[m
[31m-			done(err, user);[m
[31m-		});[m
[31m-	});[m
[31m-[m
[31m-	passport.use(new GitHubStrategy({[m
[31m-		clientID: configAuth.githubAuth.clientID,[m
[31m-		clientSecret: configAuth.githubAuth.clientSecret,[m
[31m-		callbackURL: configAuth.githubAuth.callbackURL[m
[31m-	},[m
[31m-	function (token, refreshToken, profile, done) {[m
[31m-		process.nextTick(function () {[m
[31m-			User.findOne({ 'github.id': profile.id }, function (err, user) {[m
[31m-				if (err) {[m
[31m-					return done(err);[m
[31m-				}[m
[31m-[m
[31m-				if (user) {[m
[31m-					return done(null, user);[m
[31m-				} else {[m
[31m-					var newUser = new User();[m
[31m-[m
[31m-					newUser.github.id = profile.id;[m
[31m-					newUser.github.username = profile.username;[m
[31m-					newUser.github.displayName = profile.displayName;[m
[31m-					newUser.github.publicRepos = profile._json.public_repos;[m
[31m-					newUser.nbrClicks.clicks = 0;[m
[31m-[m
[31m-					newUser.save(function (err) {[m
[31m-						if (err) {[m
[31m-							throw err;[m
[31m-						}[m
[31m-[m
[31m-						return done(null, newUser);[m
[31m-					});[m
[31m-				}[m
[31m-			});[m
[31m-		});[m
[31m-	}));[m
[31m-};[m
[1mdiff --git a/app/controllers/clickController.client.js b/app/controllers/clickController.client.js[m
[1mdeleted file mode 100644[m
[1mindex 39b3c4b..0000000[m
[1m--- a/app/controllers/clickController.client.js[m
[1m+++ /dev/null[m
[36m@@ -1,33 +0,0 @@[m
[31m-'use strict';[m
[31m-[m
[31m-(function () {[m
[31m-[m
[31m-   var addButton = document.querySelector('.btn-add');[m
[31m-   var deleteButton = document.querySelector('.btn-delete');[m
[31m-   var clickNbr = document.querySelector('#click-nbr');[m
[31m-   var apiUrl = appUrl + '/api/:id/clicks';[m
[31m-[m
[31m-   function updateClickCount (data) {[m
[31m-      var clicksObject = JSON.parse(data);[m
[31m-      clickNbr.innerHTML = clicksObject.clicks;[m
[31m-   }[m
[31m-[m
[31m-   ajaxFunctions.ready(ajaxFunctions.ajaxRequest('GET', apiUrl, updateClickCount));[m
[31m-[m
[31m-   addButton.addEventListener('click', function () {[m
[31m-[m
[31m-      ajaxFunctions.ajaxRequest('POST', apiUrl, function () {[m
[31m-         ajaxFunctions.ajaxRequest('GET', apiUrl, updateClickCount);[m
[31m-      });[m
[31m-[m
[31m-   }, false);[m
[31m-[m
[31m-   deleteButton.addEventListener('click', function () {[m
[31m-[m
[31m-      ajaxFunctions.ajaxRequest('DELETE', apiUrl, function () {[m
[31m-         ajaxFunctions.ajaxRequest('GET', apiUrl, updateClickCount);[m
[31m-      });[m
[31m-[m
[31m-   }, false);[m
[31m-[m
[31m-})();[m
[1mdiff --git a/app/controllers/clickHandler.server.js b/app/controllers/clickHandler.server.js[m
[1mdeleted file mode 100644[m
[1mindex 988f6e7..0000000[m
[1m--- a/app/controllers/clickHandler.server.js[m
[1m+++ /dev/null[m
[36m@@ -1,41 +0,0 @@[m
[31m-'use strict';[m
[31m-[m
[31m-var Users = require('../models/users.js');[m
[31m-[m
[31m-function ClickHandler () {[m
[31m-[m
[31m-	this.getClicks = function (req, res) {[m
[31m-		Users[m
[31m-			.findOne({ 'github.id': req.user.github.id }, { '_id': false })[m
[31m-			.exec(function (err, result) {[m
[31m-				if (err) { throw err; }[m
[31m-[m
[31m-				res.json(result.nbrClicks);[m
[31m-			});[m
[31m-	};[m
[31m-[m
[31m-	this.addClick = function (req, res) {[m
[31m-		Users[m
[31m-			.findOneAndUpdate({ 'github.id': req.user.github.id }, { $inc: { 'nbrClicks.clicks': 1 } })[m
[31m-			.exec(function (err, result) {[m
[31m-					if (err) { throw err; }[m
[31m-[m
[31m-					res.json(result.nbrClicks);[m
[31m-				}[m
[31m-			);[m
[31m-	};[m
[31m-[m
[31m-	this.resetClicks = function (req, res) {[m
[31m-		Users[m
[31m-			.findOneAndUpdate({ 'github.id': req.user.github.id }, { 'nbrClicks.clicks': 0 })[m
[31m-			.exec(function (err, result) {[m
[31m-					if (err) { throw err; }[m
[31m-[m
[31m-					res.json(result.nbrClicks);[m
[31m-				}[m
[31m-			);[m
[31m-	};[m
[31m-[m
[31m-}[m
[31m-[m
[31m-module.exports = ClickHandler;[m
[1mdiff --git a/app/controllers/userController.client.js b/app/controllers/userController.client.js[m
[1mdeleted file mode 100644[m
[1mindex af81c9d..0000000[m
[1m--- a/app/controllers/userController.client.js[m
[1m+++ /dev/null[m
[36m@@ -1,37 +0,0 @@[m
[31m-'use strict';[m
[31m-[m
[31m-(function () {[m
[31m-[m
[31m-   var profileId = document.querySelector('#profile-id') || null;[m
[31m-   var profileUsername = document.querySelector('#profile-username') || null;[m
[31m-   var profileRepos = document.querySelector('#profile-repos') || null;[m
[31m-   var displayName = document.querySelector('#display-name');[m
[31m-   var apiUrl = appUrl + '/api/:id';[m
[31m-[m
[31m-   function updateHtmlElement (data, element, userProperty) {[m
[31m-      element.innerHTML = data[userProperty];[m
[31m-   }[m
[31m-[m
[31m-   ajaxFunctions.ready(ajaxFunctions.ajaxRequest('GET', apiUrl, function (data) {[m
[31m-      var userObject = JSON.parse(data);[m
[31m-[m
[31m-      if (userObject.displayName !== null) {[m
[31m-         updateHtmlElement(userObject, displayName, 'displayName');[m
[31m-      } else {[m
[31m-         updateHtmlElement(userObject, displayName, 'username');[m
[31m-      }[m
[31m-[m
[31m-      if (profileId !== null) {[m
[31m-         updateHtmlElement(userObject, profileId, 'id');   [m
[31m-      }[m
[31m-[m
[31m-      if (profileUsername !== null) {[m
[31m-         updateHtmlElement(userObject, profileUsername, 'username');   [m
[31m-      }[m
[31m-[m
[31m-      if (profileRepos !== null) {[m
[31m-         updateHtmlElement(userObject, profileRepos, 'publicRepos');   [m
[31m-      }[m
[31m-[m
[31m-   }));[m
[31m-})();[m
[1mdiff --git a/app/models/users.js b/app/models/users.js[m
[1mdeleted file mode 100644[m
[1mindex 856b535..0000000[m
[1m--- a/app/models/users.js[m
[1m+++ /dev/null[m
[36m@@ -1,18 +0,0 @@[m
[31m-'use strict';[m
[31m-[m
[31m-var mongoose = require('mongoose');[m
[31m-var Schema = mongoose.Schema;[m
[31m-[m
[31m-var User = new Schema({[m
[31m-	github: {[m
[31m-		id: String,[m
[31m-		displayName: String,[m
[31m-		username: String,[m
[31m-      publicRepos: Number[m
[31m-	},[m
[31m-   nbrClicks: {[m
[31m-      clicks: Number[m
[31m-   }[m
[31m-});[m
[31m-[m
[31m-module.exports = mongoose.model('User', User);[m
[1mdiff --git a/public/login.html b/public/login.html[m
[1mdeleted file mode 100644[m
[1mindex 7903e47..0000000[m
[1m--- a/public/login.html[m
[1m+++ /dev/null[m
[36m@@ -1,27 +0,0 @@[m
[31m-<!DOCTYPE html>[m
[31m-[m
[31m-<html>[m
[31m-[m
[31m-	<head>[m
[31m-		<title>Clementine.js - The elegant and lightweight full stack JavaScript boilerplate.</title>[m
[31m-		[m
[31m-		<link href="/public/css/main.css" rel="stylesheet" type="text/css">[m
[31m-	</head>[m
[31m-[m
[31m-	<body>[m
[31m-		<div class="container">	[m
[31m-			<div class="login">[m
[31m-				<img src="/public/img/clementine_150.png" />[m
[31m-				<br />[m
[31m-				<p class="clementine-text">Clementine.js</p>[m
[31m-				<a href="/auth/github">[m
[31m-					<div class="btn" id="login-btn">[m
[31m-						<img src="/public/img/github_32px.png" alt="github logo" />[m
[31m-						<p>LOGIN WITH GITHUB</p>[m
[31m-					</div>[m
[31m-				</a>[m
[31m-			</div>[m
[31m-		</div>[m
[31m-	</body>[m
[31m-[m
[31m-</html>[m
\ No newline at end of file[m
[1mdiff --git a/public/profile.html b/public/profile.html[m
[1mdeleted file mode 100644[m
[1mindex 22b7bec..0000000[m
[1m--- a/public/profile.html[m
[1m+++ /dev/null[m
[36m@@ -1,29 +0,0 @@[m
[31m-<!DOCTYPE html>[m
[31m-[m
[31m-<html>[m
[31m-[m
[31m-	<head>[m
[31m-		<title>Clementine.js - The elegant and lightweight full stack JavaScript boilerplate.</title>[m
[31m-		[m
[31m-		<link href="/public/css/main.css" rel="stylesheet" type="text/css">[m
[31m-	</head>[m
[31m-[m
[31m-	<body>[m
[31m-		<div class="container">[m
[31m-			<div class="github-profile">[m
[31m-				<img src="/public/img/gh-mark-32px.png" alt="github logo" />[m
[31m-				<p><span>ID: </span><span id="profile-id" class="profile-value"></span></p>[m
[31m-				<p><span>Username: </span><span id="profile-username" class="profile-value"></span></p>[m
[31m-				<p><span>Display Name: </span><span id="display-name" class="profile-value"></span></p>[m
[31m-				<p><span>Repositories: </span><span id="profile-repos" class="profile-value"></span></p>[m
[31m-				<a class="menu" href="/">Home</a>[m
[31m-				<p id="menu-divide">|</p>[m
[31m-				<a class="menu" href="/logout">Logout</a>[m
[31m-			</div>[m
[31m-		</div>[m
[31m-		[m
[31m-		<script type="text/javascript" src="common/ajax-functions.js"></script>[m
[31m-		<script type="text/javascript" src="controllers/userController.client.js"></script>[m
[31m-	</body>[m
[31m-[m
[31m-</html>[m
\ No newline at end of file[m
[1mdiff --git a/server.js b/server.js[m
[1mindex e926a98..bc2ce80 100644[m
[1m--- a/server.js[m
[1m+++ b/server.js[m
[36m@@ -12,9 +12,10 @@[m [mrequire('./app/config/passport')(passport);[m
 [m
 mongoose.connect(process.env.MONGO_URI);[m
 [m
[32m+[m
 app.use('/controllers', express.static(process.cwd() + '/app/controllers'));[m
 app.use('/public', express.static(process.cwd() + '/public'));[m
[31m-app.use('/common', express.static(process.cwd() + '/app/common'));[m
[32m+[m[32mapp.use('/common', express.static(process.cwd() + '/app/common'));[m[41m [m
 [m
 app.use(session({[m
 	secret: 'secretClementine',[m
