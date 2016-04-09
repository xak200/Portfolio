var express = require('express');
var router = express.Router();
var passport = require('passport');
var mongoose = require('mongoose');
require('../db');
require('../auth');
var mealList = mongoose.model('mealList');
var itemSchema = mongoose.model('itemSchema');
var reviewSchema = mongoose.model('reviewSchema');
var User = mongoose.model('User');

/* GET home page. */
router.get('/', function(req, res, next) {
  res.render('index', { title: "Xaria's Restaurant" });
});

router.get('/meals', function(req, res) {
	mealList.find(function(err, listOfMeals, count) {
		console.log(err, listOfMeals, count);
		res.render('meals', {heading3: 'Menus',
							mealList: listOfMeals});
	});
});

router.get('/meals/:slug', function(req, res, next) {
	var admin = false;
	if ((typeof req.user != "undefined") && (req.user.username == 'xaria')) {
		admin = true;
	}
	var name = req.params.slug;
	var newName = name.replace(/\w\S*/g, function(m) { 
		return name.charAt(0).toUpperCase() + name.substr(1).toLowerCase(); 
	});
	mealList.findOne({name: newName}, function(err, menuItems, count) {
		console.log("meal name!", newName, err, menuItems, count);
		var sorted;
		if (menuItems !== null) {
			var items = menuItems.items;
			sorted = items.sort(function(a, b) {
				if (a.type > b.type) {
					return 1;
				}
				if (a.type < b.type) {
					return -1;
				}
				// a must be equal to b
				return 0;
			});
		}
		res.render('menu', {heading3: newName,
							itemList: sorted,
							administrator: admin});
	});
});

router.post('/item/create', function(req, res) {
	console.log("creating", req.body.name);
	//create item object
	var newItem = new itemSchema({
		name: req.body.name,
		vegetarian: req.body.vegetarian,
		vegan: req.body.vegan,
		price: req.body.price,
		type: req.body.type
	});
	//save item, then link new item to original list
	newItem.save(function(err, item, count) {
		console.log('made me a item', newItem.name, count, err);
		if (!err) {
			mealList.findOneAndUpdate(
				{name: req.body.mealName},
				{$push: {items: newItem}},
				{safe: true, upsert: true},
   				function(err, model) {
        			if (err) {
        				console.log("error", err);
        			}
    			}
    		);
    	}
    });
	//return to original list page
	console.log("mealname", req.body.mealName);
	res.redirect('/meals/' + req.body.mealName);
});

router.get('/reviews', function(req, res, next) {
	reviewSchema.find(function(err, reviewList, count) {
		console.log(err, reviewList, count);
		res.render('reviews', {heading3: 'Reviews',
							reviews: reviewList});
	});
});

router.post('/reviews/create', function(req,res,next) {
	//create review
	var newReview = new reviewSchema ({
		review: req.body.review,
		rating: req.body.rating,
		username: req.body.username
	});
	//save review
	newReview.save(function(err, review, count) {
		console.log('made me a review', newReview.review, count, err);
		if (!err) {
			console.log("review create", newReview.review);
    	}
    });
	//return to original reviews page
	res.redirect('/reviews');
});

router.get('/about', function(req, res, next) {
  res.render('about', {heading3: 'About'});
});

router.get('/gallery', function(req, res, next) {
  res.render('gallery', {heading3: 'Gallery'});
});

router.get('/register', function(req, res) {
	res.render('register');
});

router.post('/register', function(req, res) {
	User.register(new User({username: req.body.username}), 
		req.body.password, function(err, user){
			if (err) {
     			res.render('register',{message:'Your registration information is not valid'});
   			} else {
      			passport.authenticate('local')(req, res, function() {
        			res.redirect('/');
      			});
   			}
		});   
});

router.get('/login', function(req, res) {
	res.render('login');
});

router.post('/login', function(req,res,next) {
	passport.authenticate('local', function(err,user) {
    	if(user) {
    		passport.serializeUser(function(user, done) {
				done(null, user.id);
			});
      		req.logIn(user, function(err) {
        		res.redirect('/');
     		});
    	} else {
      		res.render('login', {message:'Your login or password is incorrect.'});
    	}
  	})(req, res, next);
});

router.get('/logout', function(req, res) {
	req.logout();
	res.redirect('/');
});

module.exports = router;
