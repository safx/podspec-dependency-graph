# base
path = require 'path'
require 'gulp-coffee'
gulp  = require 'gulp'
gutil = require 'gulp-util'

# compilers
lsc        = require 'gulp-livescript'
coffee     = require 'gulp-coffee'
uglify     = require 'gulp-uglify'
browserify = require 'gulp-browserify'
minifyHTML = require 'gulp-minify-html'
stylus     = require 'gulp-stylus'
minifyCss  = require 'gulp-minify-css'
minImage  = require 'gulp-imagemin'

# misc
clean   = require 'gulp-rimraf'
filter  = require 'gulp-filter'
cat     = require 'gulp-cat'
echo    = require 'gulp-filelog'
cond    = require 'gulp-if'
flatten = require 'gulp-flatten'
header  = require 'gulp-header'
chalk   = require 'chalk'

# packager
bower = require 'gulp-bower-files'

# live reload
livereload = require 'gulp-livereload'
server    = (require 'tiny-lr')()


isRelease = gutil.env.release?


# sources
SOURCES  = ['src/*.ls']
STYLUSES = ['stylus/*.styl']
HTMLS    = ['html/*.html']
IMAGES   = ['img/*.jpg', 'img/*.png', 'img/*.gif']


# util funcs
log = (err) ->
    if err.name? and err.message
        console.log chalk.white.bgRed.bold '[ERROR] ' + err.name
        console.log err.message
    else if typeof err == 'object'
        for k, v of err
            console.log k, v
    else
        console.log err.toString()

dest = (p) ->
  out = gutil.env.outputdir || 'app'
  gulp.dest if p? then (path.join out, p) else out


# compile
gulp.task 'script', ->
  gulp.src SOURCES
    .pipe filter('!**/main.ls')
    .pipe lsc({bare:true}) .on 'error', log
    .pipe cond isRelease, uglify()
    .pipe dest 'lib'
  return

gulp.task 'browserify', ['script'], ->
  gulp.src SOURCES
    .pipe filter('**/main.ls')
    .pipe lsc({bare:true}) .on 'error', log
    .pipe browserify()
    .pipe cond isRelease, uglify()
    .pipe dest 'lib'
    .pipe (livereload server)
  return

gulp.task 'stylus', ->
  gulp.src STYLUSES
    .pipe (stylus {bare: true}) .on 'error', log
    .pipe cond isRelease, minifyCss()
    .pipe dest 'css'
    .pipe (livereload server)
  return

gulp.task 'html', ->
  reload_script = """<script>document.write('<script src="http://' + (location.host || 'localhost').split(':')[0] + ':35729/livereload.js?snipver=1"></' + 'script>')</script>"""
  gulp.src HTMLS
    .pipe cond isRelease, minifyHTML {empty:true, cdata: true}
    .pipe cond (not isRelease), header reload_script, {}
    .pipe dest()
    .pipe (livereload server)
  return

gulp.task 'image', ->
  gulp.src IMAGES
    .pipe minImage({progressive:true})
    .pipe dest 'img'
  return

gulp.task 'bower', ->
  bower()
    .pipe cond isRelease, uglify({preserveComments:'some'})
    .pipe flatten()
    .pipe dest 'lib'
    .pipe (livereload server)

gulp.task 'copy', ->
  gulp.src 'third_party/**/*.js'
    .pipe cond isRelease, uglify({preserveComments:'some'})
    .pipe dest 'lib'
    .pipe (livereload server)
  gulp.src ['data/*.gexf', 'data/*.json']
    .pipe dest 'data'
  return
    
gulp.task 'watch', ->
  server.listen 35729, (err) ->
    if err
      console.log err
      return
    gulp.watch SOURCES, ['browserify']
    gulp.watch STYLUSES, ['stylus']
    gulp.watch HTMLS, ['html']
    gulp.watch IMAGES, ['image']
    


# misc
gulp.task 'clean', ['clean:out', 'clean:backup']

gulp.task 'clean:backup', ->
  gulp.src '**/*~'
    .pipe clean()

gulp.task 'clean:out', ->
  gulp.src [out 'data', out 'css', out 'lib', out '*.html']
    .pipe clean()



gulp.task 'publish', ['clean', 'browserify', 'stylus', 'html', 'image', 'copy']
gulp.task 'default', ['browserify', 'stylus', 'html', 'image', 'copy', 'watch']
