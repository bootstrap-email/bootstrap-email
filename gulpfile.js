var gulp = require('gulp');
var sass = require('gulp-sass');
var inlineCss = require('gulp-inline-css');
var cheerio = require('gulp-cheerio');
var wrap = require('gulp-wrap');
var styleInject = require("gulp-style-inject");

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
      $('*[class^=p-],*[class^=pt-],*[class^=pr-],*[class^=pb-],*[class^=pl-],*[class^=px-],*[class^=py-]').each(function(){
        $(this).replaceWith($('<table class="'+$(this).attr('class')+'"><tr><td>'+$.html($(this))+'</td></tr></table>'));
      });
      $('.btn').each(function(){
        $(this).replaceWith($('<table class="'+$(this).attr('class')+'" align="left"><tr><td>'+$.html($(this).removeAttr('class'))+'</td></tr></table>'));
      });
      $('.alert').each(function(){
        $(this).replaceWith($('<table class="'+$(this).attr('class')+'"><tr><td>'+$.html($(this).removeAttr('class'))+'</td></tr></table>'));
      });
      $('.align-left').each(function(){
        $(this).replaceWith($('<table align="left"><tr><td>'+$.html($(this))+'</td></tr></table>'));
      });
      $('.align-center').each(function(){
        $(this).replaceWith($('<table align="center"><tr><td>'+$.html($(this))+'</td></tr></table>'));
      });
      $('.align-right').each(function(){
        $(this).replaceWith($('<table align="right"><tr><td>'+$.html($(this))+'</td></tr></table>'));
      });
      $('.card').each(function(){
        $(this).replaceWith($('<table class="'+$(this).attr('class')+'"><tr><td>'+$.html($(this).removeAttr('class'))+'</td></tr></table>'));
      });
      $('.card-body').each(function(){
        $(this).replaceWith($('<table class="'+$(this).attr('class')+'"><tr><td>'+$.html($(this).removeAttr('class'))+'</td></tr></table>'));
      });
      $('hr').each(function(){
        $(this).replaceWith($('<table class="hr"><tr><td><table><tr><td></td></tr></table></td></tr></table>'));
      });
      $('p').each(function(){
        $(this).replaceWith($('<table class="p"><tr><td>'+$.html($(this))+'</td></tr></table>'));
      });
      $('.container').each(function(){
        $(this).replaceWith($('<table class="'+$(this).attr('class')+'"><tr><td><!--[if (gte mso 9)|(IE)]><table align="center"><tr><td width="600"><![endif]--><table align="center"><tr><td>'+$(this).html()+'</td></tr></table><!--[if (gte mso 9)|(IE)]></td></tr></table><![endif]--></td></tr></table>'));
      });
      $('.row').each(function(){
        $(this).replaceWith($('<table class="'+$(this).attr('class')+'"><tr>'+$(this).html()+'</tr></table>'));
      });
      $('*[class^=col]').each(function(){
        $(this).replaceWith($('<th class="'+$(this).attr('class')+'" align="left" valign="top">'+$(this).html()+'</th>'));
      });
    }))
    .pipe(inlineCss({
      applyStyleTags: true,
      applyLinkTags: true,
      removeStyleTags: false,
      removeLinkTags: true,
      applyTableAttributes: true,
      preserveMediaQueries: true,
      extraCss: './css/head.css'
    }))
    .pipe(gulp.dest('./examples/inlined/'));
});

gulp.task('build', ['sass', 'sass:head', 'cheerio']);
