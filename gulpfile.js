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
      $('.btn').each(function(){ // move all classes up and remove all classes from element
        buildFromTemplate.call(this, $, 'table-left', {classes: $(this).attr('class'), contents: $.html($(this).removeAttr('class'))});
      });
      $('.badge').each(function(){ // move all classes up and remove all classes from element
        buildFromTemplate.call(this, $, 'table-left', {classes: $(this).attr('class'), contents: $.html($(this).removeAttr('class'))});
      });
      $('.alert').each(function(){ // move all classes up and remove all classes from element
        buildFromTemplate.call(this, $, 'table', {classes: $(this).attr('class'), contents: $.html($(this).removeAttr('class'))});
      });
      $('.align-left').each(function(){ // align table and move contents
        buildFromTemplate.call(this, $, 'align-left', {contents: $.html($(this))});
      });
      $('.align-center').each(function(){ // align table and move contents
        buildFromTemplate.call(this, $, 'align-center', {contents: $.html($(this))});
      });
      $('.align-right').each(function(){ // align table and move contents
        buildFromTemplate.call(this, $, 'align-right', {contents: $.html($(this))});
      });
      $('.card').each(function(){ // move all classes up and remove all classes from element
        buildFromTemplate.call(this, $, 'table', {classes: $(this).attr('class'), contents: $.html($(this).removeAttr('class'))});
      });
      $('.card-body').each(function(){ // move all classes up and remove all classes from element
        buildFromTemplate.call(this, $, 'table', {classes: $(this).attr('class'), contents: $.html($(this).removeAttr('class'))});
      });
      $('hr').each(function(){ // drop hr in place of current
        buildFromTemplate.call(this, $, 'hr', {});
      });
      $('p').each(function(){
        buildFromTemplate.call(this, $, 'table', {classes: 'p', contents: $.html($(this))});
      });
      $('.container').each(function(){
        buildFromTemplate.call(this, $, 'container', {classes: $(this).attr('class'), contents: $(this).html()});
      });
      $('.container-fluid').each(function(){
        buildFromTemplate.call(this, $, 'table', {classes: $(this).attr('class'), contents: $(this).html()});
      });
      $('.row').each(function(){
        buildFromTemplate.call(this, $, 'row', {classes: $(this).attr('class'), contents: $(this).html()});
      });
      $('*[class^=col]').each(function(){
        buildFromTemplate.call(this, $, 'col', {classes: $(this).attr('class'), contents: $(this).html()});
      });
      $('*[class^=p-]').each(function(){
        console.log('made it');
        if($(this).tagName != 'table'){
          buildFromTemplate.call(this, $, 'table', {classes: $(this).attr('class'), contents: $.html($(this))});
        }
      });
      $('.m-1,.m-2,.m-3,.m-4,.m-5,.mt-1,.mt-2,.mt-3,.mt-4,.mt-5,.mr-1,.mr-2,.mr-3,.mr-4,.mr-5,.mb-1,.mb-2,.mb-3,.mb-4,.mb-5,.ml-1,.ml-2,.ml-3,.ml-4,.ml-5,.mx-1,.mx-2,.mx-3,.mx-4,.mx-5,.my-1,.my-2,.my-3,.my-4,.my-5').each(function(){
        console.log('made it 2222222');
        if($(this).tagName != 'div'){
          buildFromTemplate.call(this, $, 'div', {classes: $(this).attr('class').match(/m([trblxy]?-\d)/g).join(' '), contents: $.html($(this))});
        }
      });
      // $('.m-1,.m-2,.m-3,.m-4,.m-5,.mt-1,.mt-2,.mt-3,.mt-4,.mt-5,.mr-1,.mr-2,.mr-3,.mr-4,.mr-5,.mb-1,.mb-2,.mb-3,.mb-4,.mb-5,.ml-1,.ml-2,.ml-3,.ml-4,.ml-5,.mx-1,.mx-2,.mx-3,.mx-4,.mx-5,.my-1,.my-2,.my-3,.my-4,.my-5').each(function(){
      //   // make margins into a new empty table and make it a padding class
      //   buildFromTemplate.call(this, $, 'basic-table', {classes: $(this).attr('class').replace(/m([trblxy]?-\d)/g, "p$1").match(/p[trblxy]?-\d/g).join(' '), contents: $.html($(this))});
      // });

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
