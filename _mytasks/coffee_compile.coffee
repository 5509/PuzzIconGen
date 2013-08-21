module.exports = (grunt) ->

  grunt.loadNpmTasks('grunt-contrib-coffee')

  grunt.config.set('coffee', {
    glob_to_multiple: {
      expand: true
      cwd: '_sources/scripts/coffee'
      src: [
        'app/*.coffee'
        'controller/*.coffee'
        'collection/*.coffee'
        'model/*.coffee'
        'view/*.coffee'
      ]
      dest: 'scripts/tmp'
      ext: '.js'
    }
  })