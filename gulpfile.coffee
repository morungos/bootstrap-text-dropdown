gulp = require 'gulp'

less = require 'gulp-less'
rename = require 'gulp-rename'
jasmine = require 'gulp-jasmine'
notify = require 'gulp-notify'
coffee = require 'gulp-coffee'
filter = require 'gulp-filter'
mainBowerFiles = require 'main-bower-files'


gulp.task 'less', () ->
  gulp.src './build/build.less'
    .pipe less {paths: "./less", verbose: true}
    .pipe rename 'text-dropdown.css'
    .pipe gulp.dest('./css')

gulp.task 'coffee', () ->
  gulp.src(['./coffee/**/*.*coffee'])
    .pipe coffee()
    .pipe gulp.dest './.tmp/js/'

gulp.task 'vendors', () ->
  gulp.src mainBowerFiles() 
    .pipe gulp.dest './.tmp/vendors/'

gulp.task 'test', ['coffee', 'vendors'], () ->
  gulp.src './.tmp/js/**/*_test.js'
    .pipe jasmine()
    .on 'error', notify.onError({
      title: 'Jasmine Test Failed',
      message: 'One or more tests failed, see the cli for details.'
    })