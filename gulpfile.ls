require! gulp
require! "main-bower-files"
$ = do (require "gulp-load-plugins")

getJs = ->
  gulp.src "app/hello.ls"
    .pipe $.livescript!
    .pipe $.size showFiles: true
    .pipe $.ngAnnotate!

gulp.task "default", ->
  getJs!
    .pipe gulp.dest "public"

  gulp.src "app/index.jade"
    .pipe $.jade!
    .pipe gulp.dest "public"

  gulp.src "app/hello.styl"
    .pipe $.stylus!
    .pipe gulp.dest "public"

  gulp.src mainBowerFiles!
    .pipe $.filter "*.js"
    .pipe $.size showFiles: true
    .pipe $.concat "vendor.js"
    .pipe gulp.dest "public"

  gulp.src "bower_components/angular-material/angular-material.min.css"
    .pipe gulp.dest "public"

  gulp.src "bower_components/components-font-awesome/fonts/*"
    .pipe gulp.dest "public/fonts"

  gulp.src "bower_components/components-font-awesome/css/font-awesome.min.css"
    .pipe gulp.dest "public"

gulp.task "closure-compiler", ->
  getJs!
    .pipe $.closureCompiler(
      compilerPath: "bower_components/closure-compiler/compiler.jar"
      fileName: "hello.js"
      warning_level: "VERBOSE"
      externs:
        "support/externs/angular-1.2.js"
        "support/externs/externs.js"
    )
    .pipe $.size showFiles: true
    .pipe gulp.dest "tmp"
