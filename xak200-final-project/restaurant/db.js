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