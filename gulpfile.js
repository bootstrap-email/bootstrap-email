var gulp = require('gulp');
var sass = require('gulp-sass');
var inlineCss = require('gulp-inline-css');
var cheerio = require('gulp-cheerio');
var wrap = require('gulp-wrap');
var styleInject = require('gulp-style-inject');
var prettify = require('gulp-jsbeautifier');
var fs = require('fs');
var _ = require('lodash');

gulp.task('sass', function () {
  return gulp.src('./sass/email.scss')
    .pipe(sass().on('error', sass.logError))
    .pipe(gulp.dest('./css'));
});

gulp.task('sass:head', function () {
  return gulp.src('./sass/head.scss')
    .pipe(sass().on('error', sass.logError))
    .pipe(gulp.dest('./css'));
});

gulp.task('sass:watch', function () {
  gulp.watch('./sass/*.scss', ['sass']);
});

gulp.task('examples', function() {
  return gulp.src('./examples/preinlined/*.html')
    .pipe(inlineCss({
      applyStyleTags: true,
      applyLinkTags: true,
      removeStyleTags: false,
      removeLinkTags: true,
      applyTableAttributes: true,
      preserveMediaQueries: true
    }))
    .pipe(gulp.dest('./examples/inlined/'));
});

gulp.task('cheerio', function() {
  return gulp.src('./examples/preinlined/*.html')
    .pipe(wrap({ src: 'template.html'}))
    .pipe(styleInject())
    .pipe(cheerio(function ($, file) {
      $('.btn').each(function(){
        buildFromTemplate.call(this, $, 'basic-table-left', {classes: $(this).attr('class'), contents: $.html($(this).removeClass('btn'))});
      });
      $('.badge').each(function(){
        buildFromTemplate.call(this, $, 'basic-table-left', {classes: $(this).attr('class'), contents: $.html($(this).removeClass('badge'))});
      });
      $('.alert').each(function(){
        buildFromTemplate.call(this, $, 'basic-table', {classes: $(this).attr('class'), contents: $.html($(this).removeClass('alert'))});
      });
      $('.align-left').each(function(){
        buildFromTemplate.call(this, $, 'align-left', {contents: $.html($(this))});
      });
      $('.align-center').each(function(){
        buildFromTemplate.call(this, $, 'align-center', {contents: $.html($(this))});
      });
      $('.align-right').each(function(){
        buildFromTemplate.call(this, $, 'align-right', {contents: $.html($(this))});
      });
      $('.card').each(function(){
        buildFromTemplate.call(this, $, 'basic-table', {classes: $(this).attr('class'), contents: $.html($(this).removeClass('card'))});
      });
      $('.card-body').each(function(){
        buildFromTemplate.call(this, $, 'basic-table', {classes: $(this).attr('class'), contents: $.html($(this).removeClass('card-body'))});
      });
      $('hr').each(function(){
        buildFromTemplate.call(this, $, 'hr', {});
      });
      $('p').each(function(){
        buildFromTemplate.call(this, $, 'basic-table', {classes: 'p', contents: $.html($(this))});
      });
      $('.container').each(function(){
        buildFromTemplate.call(this, $, 'container', {classes: $(this).attr('class'), contents: $(this).html()});
      });
      $('.row').each(function(){
        buildFromTemplate.call(this, $, 'row', {classes: $(this).attr('class'), contents: $(this).html()});
      });
      $('*[class^=col]').each(function(){
        buildFromTemplate.call(this, $, 'col', {classes: $(this).attr('class'), contents: $(this).html()});
      });
      $('*[class^=m-],*[class^=mt-],*[class^=mr-],*[class^=mb-],*[class^=ml-],*[class^=mx-],*[class^=my-]').each(function(){
        // make margins into a new empty table and make it a padding class
        buildFromTemplate.call(this, $, 'basic-table', {classes: $(this).attr('class').replace(/m([trblxy]?-\d)/g, 'p$1').match(/p[trblxy]?-\d/g), contents: $.html($(this))});
      });
    }))
    .pipe(inlineCss({
      applyStyleTags: false,
      applyLinkTags: true,
      removeStyleTags: false,
      removeLinkTags: true,
      applyTableAttributes: true,
      preserveMediaQueries: true,
      extraCss: './css/head.css'
    }))
    .pipe(prettify({indent_size: 2}))
    .pipe(gulp.dest('./examples/inlined/'));
});

gulp.task('build', ['sass', 'sass:head', 'cheerio']);

function buildFromTemplate($, template, obj){
  var temp = _.template(fs.readFileSync('./templates/'+template+'.html', 'utf8'));
  var res = temp(obj);
  $(this).replaceWith(res);
}
