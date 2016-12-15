var gulp = require('gulp');
var sass = require('gulp-sass');
var inlineCss = require('gulp-inline-css');

gulp.task('sass', function () {
  return gulp.src('./sass/email.scss')
    .pipe(sass().on('error', sass.logError))
    .pipe(gulp.dest('./css'));
});

gulp.task('sass:watch', function () {
  gulp.watch('./sass/*.scss', ['sass']);
});

gulp.task('sass:build', function () {
  gulp.run('sass');
});

gulp.task('examples', function() {
  return gulp.src('./examples/preinlined/*.html')
    .pipe(inlineCss({
      applyStyleTags: false,
      applyLinkTags: true,
      removeStyleTags: false,
      removeLinkTags: true
    }))
    .pipe(gulp.dest('./examples/inlined/'));
});
