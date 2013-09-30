module.exports = (grunt) ->

  grunt.loadNpmTasks('grunt-contrib-coffee')

  grunt.config.set('coffee', {
    glob_to_multiple: {
      expand: true
      cwd: '_sources/scripts/coffee'
      src: [
        'app/*.coffee'
        'controller/base.coffee'
        'controller/app.coffee'
        'model/app.coffee'
        'view/app.coffee'
        'view/preview.coffee'
      ]
      dest: 'scripts/tmp'
      ext: '.js'
    }
  })