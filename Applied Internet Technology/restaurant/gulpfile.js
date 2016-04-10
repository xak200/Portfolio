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