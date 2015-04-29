#gulp        = require "gulp"
#jade        = require "gulp-jade"
#sass        = require "gulp-sass"
#sourcemaps  = require "gulp-sourcemaps"
#coffee      = require "gulp-coffee"
#concat      = require "gulp-concat"
#nodemon     = require "gulp-nodemon"
#notify      = require "gulp-notify"
#del         = require "del"
#es          = require "event-stream"
#
#
#default_dependencies = ["stylesheets", "fonts", "images", "scripts"]
#if env is "development"
#  default_dependencies.push "watch"
#
#paths =
#  stylesheets:  "src/stylesheets/**/*"
#  images:       "src/images/**/*.*"
#  coffee:       "src/scripts/**/*.coffee"
#  jade:         "src/scripts/**/*.jade"
#
#gulp.task 'stylesheets', ->
#  gulp.src "src/stylesheets/index.scss"
#  .pipe sass(includePaths: ['./node_modules/bootstrap-sass/assets/stylesheets'])
#  .on "error", notify.onError (error) ->
#    "Error: #{error.message}"
#  .pipe gulp.dest './public/stylesheets/'
#
#gulp.task 'fonts',  ->
#  gulp.src './node_modules/bootstrap-sass/assets/fonts/**/*'
#  .pipe gulp.dest 'public/fonts/'
#
#gulp.task "images", ["cleanImages"], ->
#  gulp.src paths.images
#  .pipe gulp.dest "public/images/"
#
#gulp.task "cleanImages", (cb) ->
#  del ['public/images'], cb
#
#gulp.task "scripts", ["cleanScripts"], ->
#
#  templates = gulp.src paths.jade
#  .pipe jade client: true
#  .pipe wrap deps: ['runtime'], params: ['jade']
#  .pipe gulp.dest "public/scripts/"
#
#  app = gulp.src paths.coffee
#  .pipe coffee()
#  .pipe gulp.dest "public/scripts/"
#
#  vendor = gulp.src paths.vendor_js
#  .pipe gulp.dest "public/scripts/vendor/"
#
#  es.merge vendor, app, templates
#  .pipe amdOptimize "main", amdOptimize_options
#  .pipe concat "index.js"
#  .pipe gulp.dest "public/scripts/"
#
#gulp.task "cleanScripts", (cb) ->
#  del 'public/scripts', cb
#
#gulp.task "watch", ->
#  gulp.watch paths.stylesheets, ["stylesheets"]
#  gulp.watch paths.images, ["images"]
#  gulp.watch paths.coffee, ["scripts"]
#  gulp.watch paths.jade, ["scripts"]
#  return
#
#
#gulp.task "default", default_dependencies, ->
#  nodemon
#    script: "app.coffee"
#    ignore: ['./public/']
#  # nodeArgs: ['--nodejs', '--debug']
#  # node inspector is running on http://127.0.0.1:8080/debug?port=5858
#  return

gulp = require('gulp')
gutil = require('gulp-util')
sourcemaps = require('gulp-sourcemaps')
source = require('vinyl-source-stream')
buffer = require('vinyl-buffer')
watchify = require('watchify')
browserify = require('browserify')
nodemon = require('nodemon')
sass = require('gulp-sass')

bundler = watchify(browserify('./assets/scripts/index.coffee', {transform: ['coffeeify'], extensions: ['.coffee']}))
# on any dep update, runs the bundler

bundle = ->
  bundler.bundle()
    .on('error', gutil.log.bind(gutil, 'Browserify Error'))
    .pipe(source('bundle.js'))
    .pipe(buffer())
    .pipe(sourcemaps.init(loadMaps: true))
    .pipe(sourcemaps.write('./'))
    .pipe gulp.dest('./public/scripts')

styler = ->
  console.log 'building styles'
  gulp.src('./assets/stylesheets/style.scss')
    .pipe sass()
    .pipe gulp.dest('./public/styles')

gulp.task 'scripts', bundle
# so you can run `gulp js` to build the file
bundler.on 'update', bundle

gulp.task 'styles', ->
  gulp.watch './assets/stylesheets/**/*.scss', styler
  styler()

gulp.task 'default', [
  'scripts'
  'styles'
], ->
  nodemon
    'script': 'app.coffee'
    'ignore': [
      './assets/'
      './public/'
    ]
  return
