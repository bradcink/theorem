"use strict"

path = require('path')

module.exports = (grunt) ->

  # Project Configuration
  grunt.initConfig
    pkg: grunt.file.readJSON("./package.json")
    bower: grunt.file.readJSON("./.bowerrc")

    notify_hooks:
      options:
        enabled: true
        title: "Props"

    watch:
      serverViews:
        files: ["app/views/**"]
        options:
          livereload: true

      serverJS:
        files: [
          "server.coffee"
          "config/**/*.coffee"
          "app/**/*.coffee"
        ]
        options:
          livereload: false

      bower:
        files: ['public/lib/**/*']
        tasks: ['wiredep', 'concat:parallel']
        options:
          livereload: true

      clientCoffee:
        files: ["client/**/*.coffee"]
        tasks: ["newer:coffee:client", "injector", "notify:coffee"]
        options:
          livereload: true

      clientLESS:
        files: ["client/**/*.less"]
        tasks: ["less:client", "notify:less"]
        options:
          livereload: true

      clientJade:
        files: ["client/modules/**/views/**/*.jade"]
        tasks: ["newer:jade:client", "notify:jade"]
        options:
          livereload: true

    clean:
      js: ["public/app/*.js", "public/modules/**/*.js"]
      css: ["public/modules/**/*.css"]
      html: ["public/modules/**/*.html"]

    notify:
      less:
        options:
          message: 'Less has finished compiling'

      jade:
        options:
          message: 'Jade has finished compiling'

      coffee:
        options:
          message: 'Coffeescript has finished compiling'

      compiling:
        options:
          message: 'Finished Compiling'

    less:
      client:
        expand: true
        flatten: false
        cwd: 'client/'
        src: 'modules/core/styles/core.less'
        dest: 'public/'
        ext: '.css'

    jade:
      client:
        options:
          pretty: false
        expand: true
        flatten: false
        cwd: 'client/'
        src: '**/*.jade'
        dest: 'public/'
        ext: '.html'
      prod:
        options:
          pretty: false
        expand: true
        flatten: false
        cwd: 'client/'
        src: '**/*.jade'
        dest: 'public/'
        ext: '.html'

    coffee:
      client:
        options:
          bare: true  # No wrapper js
        expand: true
        flatten: false
        cwd: 'client/'
        src: '**/*.coffee'
        dest: 'public/'
        ext: '.js'
      prod:
        options:
          bare: true  # No wrapper js
        expand: true
        flatten: false
        cwd: 'client/'
        src: '**/*.coffee'
        dest: 'public/'
        ext: '.js'

    start:
      script: "app/app.coffee"

    # nodemon:
    #   dev:
    #     script: "server.coffee"
    #     options:
    #       # nodeArgs: ["--debug"]
    #       ignore: ["gruntfile.coffee", ".DS_Store", ".git/**", "public/**/*", "test/**", "tmp/**", "node_modules/**", "client/**/*"]
    #       ext: 'js,coffee,less,jade'
    #       callback: ((nodemon) ->
    #         nodemon.on('log', (event)->
    #           console.log(event.colour)
    #         )

    #         # refresh on server reboot
    #         nodemon.on('restart', ()->
    #           # delay before server listens on port
    #           console.log('Writing to .grunt_rebooted')
    #           setTimeout(()->
    #             console.log('Live Reload')
    #             require('fs').writeFileSync('.grunt_rebooted', 'rebooted')
    #           , 3000)
    #         )
    #       )

    # concurrent:
    #   tasks: [
    #     "nodemon"
    #     "watch"
    #   ]
    #   options:
    #     logConcurrentOutput: true

    env:
      test:
        NODE_ENV: "test"


  # Load NPM tasks
  grunt.loadNpmTasks "grunt-contrib-watch"
  grunt.loadNpmTasks "grunt-contrib-clean"
  grunt.loadNpmTasks "grunt-contrib-concat"
  grunt.loadNpmTasks "grunt-contrib-coffee"
  grunt.loadNpmTasks "grunt-contrib-jade"
  grunt.loadNpmTasks "grunt-contrib-less"

  grunt.loadNpmTasks "grunt-angular-templates"
  grunt.loadNpmTasks "grunt-notify"
  # grunt.loadNpmTasks "grunt-nodemon"
  # grunt.loadNpmTasks "grunt-concurrent"
  # grunt.loadNpmTasks "grunt-env"

  # Making grunt default to force in order not to break the project.
  # grunt.option "force", true

  grunt.registerTask "default", [
    # "build"
    # "concurrent"
    # "start"
  ]

  grunt.registerTask "build", [
    "clean:js"
    "clean:css"
    "clean:html"
    "coffee:client"
    "jade:client"
    "less:client"
  ]

  return
