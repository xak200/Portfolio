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
