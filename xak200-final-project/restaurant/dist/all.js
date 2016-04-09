var passport = require('passport');
var express = require('express');
var path = require('path');
var favicon = require('serve-favicon');
var logger = require('morgan');
var cookieParser = require('cookie-parser');
var bodyParser = require('body-parser');
var session = require('express-session');

var routes = require('./routes/index');
var users = require('./routes/users');

var app = express();

// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'hbs');

// uncomment after placing your favicon in /public
//app.use(favicon(path.join(__dirname, 'public', 'favicon.ico')));
app.use(logger('dev'));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

var sessionOptions = {
	secret: 'secret cookie thang (store this elsewhere!)',
	resave: true,
	saveUninitialized: true
};
app.use(session(sessionOptions));

app.use(passport.initialize());
app.use(passport.session());

app.use(function(req, res, next){
	res.locals.user = req.user;
	next();
});

app.use('/', routes);
app.use('/users', users);

// catch 404 and forward to error handler
app.use(function(req, res, next) {
  var err = new Error('Not Found');
  err.status = 404;
  next(err);
});

// error handlers

// development error handler
// will print stacktrace
if (app.get('env') === 'development') {
  app.use(function(err, req, res, next) {
    res.status(err.status || 500);
    res.render('error', {
      message: err.message,
      error: err
    });
  });
}

// production error handler
// no stacktraces leaked to user
app.use(function(err, req, res, next) {
  res.status(err.status || 500);
  res.render('error', {
    message: err.message,
    error: {}
  });
});


module.exports = app;

var mongoose = require('mongoose'),
    passport = require('passport'),
    LocalStrategy = require('passport-local').Strategy,
    User = mongoose.model('User');

// NOTE: passport-local-mongoose gives back a function 
// that does the authentication for us. The plugin adds
// a static authenticate method to our schema that 
// returns a function... we can check out how it works
passport.use(new LocalStrategy(User.authenticate()));

// NOTE: specify how we save and retrieve the user object
// from the session; rely on passport-local-mongoose's
// functions that are added to the user model
passport.serializeUser(User.serializeUser());
passport.deserializeUser(User.deserializeUser());

var mongoose = require('mongoose');
var URLSlugs = require('mongoose-url-slugs');
var passportLocalMongoose = require('passport-local-mongoose');
var UserSchema = new mongoose.Schema({ });

// NOTE: we're using passport-local-mongoose as a plugin
// our schema for user looks pretty thin... but that's because
// the plugin inserts salt, password and username
UserSchema.plugin(passportLocalMongoose);

//my schema goes here	
	
var Schema = mongoose.Schema;

var itemSchema = new Schema ({
	name: String,
	vegetarian: Boolean,
	vegan: Boolean,
	price: Number,
	type: String		//appetizer, beverage, main, side, dessert
});

var mealList = new Schema ({
	name: String,		//breakfast, brunch, dinner
	hours: String,
	items: [itemSchema]		//all items
});

var reviewSchema = new Schema ({
	review: String, 
	rating: Number,
	username: String
});

//slugs

mealList.plugin(URLSlugs('name'));
itemSchema.plugin(URLSlugs('type name'));
reviewSchema.plugin(URLSlugs('review'));

mongoose.model('mealList', mealList);
mongoose.model('itemSchema', itemSchema);
mongoose.model('reviewSchema', reviewSchema);
mongoose.model('User', UserSchema);
mongoose.connect('mongodb://localhost:10321/restaurant');
// Include gulp
var gulp = require('gulp'); 

// Include Our Plugins
var jshint = require('gulp-jshint');
//var sass = require('gulp-sass');
var concat = require('gulp-concat');
var uglify = require('gulp-uglify');
var rename = require('gulp-rename');
var less = require('gulp-less');

// Lint Task
gulp.task('lint', function() {
    return gulp.src(['*.js', 'routes/*.js'])
        .pipe(jshint())
        .pipe(jshint.reporter('default'));
});

// Compile Our Sass
// gulp.task('sass', function() {
//     return gulp.src('scss/*.scss')
//         .pipe(sass())
//         .pipe(gulp.dest('css'));
// });
gulp.task('less', function() {
    return gulp.src('./less/*.less')
        .pipe(less())
        .pipe(gulp.dest('./public/stylesheets'));
});

// Concatenate & Minify JS
gulp.task('scripts', function() {
    return gulp.src(['*.js', 'routes/*.js'])
        .pipe(concat('all.js'))
        .pipe(gulp.dest('dist'))
        .pipe(rename('all.min.js'))
        .pipe(uglify())
        .pipe(gulp.dest('dist'));
});

// Watch Files For Changes
gulp.task('watch', function() {
    gulp.watch(['*.js', 'routes/*.js'], ['lint', 'scripts']);
   //  gulp.watch('scss/*.scss', ['sass']);
    gulp.watch('less/*.less', ['less']);
});

// Default Task
gulp.task('default', ['lint', 'less', 'scripts', 'watch']);
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

var express = require('express');
var router = express.Router();

/* GET users listing. */
router.get('/', function(req, res, next) {
  res.send('respond with a resource');
});

module.exports = router;
