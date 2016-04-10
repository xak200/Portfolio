# xak200-final-project

![Alt text](./documentation/cookies.jpg?raw=true "Optional Title")

Description:  

My project will be the website for a restaurant, supplying potential or returning customers with contact information and what the restaurant has to offer. Additionally, customers will be able to write reviews through the website.


Requirements:  

schemas:  

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
	
	var UserSchema = new mongoose.Schema({ });

-wireframes
----------------------------------------------------------------
Homepage:
![Wireframes](./documentation/Homepage.png?raw=true "Wireframes")
----------------------------------------------------------------
Breakfast Menu:
![Wireframes](./documentation/Breakfast.png?raw=true "Wireframes")
----------------------------------------------------------------
Brunch Menu:
![Wireframes](./documentation/Brunch.png?raw=true "Wireframes")
----------------------------------------------------------------
Dinner Menu:
![Wireframes](./documentation/Dinner.png?raw=true "Wireframes")
----------------------------------------------------------------
Reviews
![Wireframes](./documentation/Reviews.png?raw=true "Wireframes")
----------------------------------------------------------------
About:
![Wireframes](./documentation/About.png?raw=true "Wireframes")
----------------------------------------------------------------
Gallery:
![Wireframes](./documentation/Gallery.png?raw=true "Wireframes")
----------------------------------------------------------------

-site map
![Site maps](./documentation/sitemap.png?raw=true "Site Maps")

-what it does(user stories, use case diagram):
* 'as a customer, i want to know the address of the restaurant'
* 'as a customer, i want to know what's available for breakfast, brunch, and dinner'
* 'as an authenticated customer, i want to be able to write reviews'
* 'as an admin, i want to be able to add items to the menu'

-modules researched and used(9 pts):
* (3 pts) User authentication 
* (1 pt) Pre-built Express templates
* (1 pt) Integrate JSHint into your workflow
* (1 pt) Use grunt, gulp, or even make (!) to automate any of the following … must be used in combination with one or more of the other requirements, such as:
	Automated minification and concatenation of JavaScript and CSS files
	Automated compiling of CSS preprocessing language
	Running your unit or functional tests
* (1 pt) Automated minification
* (1 pt) CSS Preprocesser -Less
* (1 pt/lib) Use a client-side JavaScript library (JQuery)
* (1 pt) Responsive Design 

ADDITIONAL INFO:
* Log in as 'xaria', with password: 'kirtikar' to be logged in as admin, and to add items to menu.
* Register/login as yourself (or anyone else) to create reviews.