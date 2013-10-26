module.exports = (grunt) ->

  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-contrib-connect')
  grunt.loadNpmTasks('grunt-contrib-jshint')
  grunt.loadNpmTasks('grunt-contrib-uglify')
  grunt.loadNpmTasks('grunt-contrib-watch')
  grunt.loadNpmTasks('grunt-contrib-yuidoc')

  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')
    # local Server
    connect:
      server:
        options:
          port: 9000

    # watch
    watch:
      html_files:
        files: '**/**.html'
      coffee:
        files: 'source/coffee/*.coffee'
        tasks: ['coffee:compile']
      scripts:
        files: 'js/pocket.js'
        tasks: ['uglify', "yuidoc"]
      options:
        livereload: true

    # coffee
    coffee:
      compile:
        options:
          bare: true
        files:
          "js/pocket.js": "source/coffee/pocket.coffee"

    # 圧縮
    uglify:
      my_target:
        files:
          "js/pocket.min.js": ["js/pocket.js"]

    # ドキュメント生成
    yuidoc:
      compile:
        name: "<%= pkg.name %>"
        description: "<%= pkg.description %>"
        version: "<%= pkg.version %>"
        url: "<%= pkg.homepage %>"
        options:
          paths: "js/"
          outdir: "docs/"

  # start local server
  grunt.registerTask "default", ["connect", "watch"]

  # "default" でデフォルトのタスクを設定
  grunt.registerTask "release", ["uglify", "yuidoc"]
