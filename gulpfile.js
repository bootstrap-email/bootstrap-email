var gulp = require('gulp');
var sass = require('gulp-sass');
var inlineCss = require('gulp-inline-css');
var cheerio = require('gulp-cheerio');

gulp.task('sass', function () {
  return gulp.src('./sass/email.scss')
    .pipe(sass().on('error', sass.logError))
    .pipe(gulp.dest('./css'));
});

gulp.task('sass:watch', function () {
  gulp.watch('./sass/*.scss', ['sass']);
});

gulp.task('examples', function() {
  return gulp.src('./examples/preinlined/*.html')
    .pipe(inlineCss({
      applyStyleTags: false,
      applyLinkTags: true,
      removeStyleTags: false,
      removeLinkTags: true,
      applyTableAttributes: true
    }))
    .pipe(gulp.dest('./examples/inlined/'));
});

gulp.task('cheerio', function() {
  return gulp.src('./examples/preinlined/*.html')
    .pipe(cheerio(function ($, file) {
      $('.btn').each(function(){
        $(this).replaceWith($('<table class="'+$(this).attr('class')+'" align="left"><tr><td>'+$.html($(this).removeAttr('class'))+'</td></tr></table>'));
      });
    }))
    .pipe(inlineCss({
      applyStyleTags: false,
      applyLinkTags: true,
      removeStyleTags: false,
      removeLinkTags: true,
      applyTableAttributes: true
    }))
    .pipe(gulp.dest('./examples/inlined/'));
});

gulp.task('build', ['sass', 'cheerio']);
