module.exports = (grunt) ->

  grunt.loadNpmTasks('grunt-contrib-coffee')

  grunt.config.set('coffee', {
    glob_to_multiple: {
      expand: true
      cwd: '_sources/scripts/coffee'
      src: ['*.coffee']
      dest: '_sources/scripts/tmp/'
      ext: '.js'
    }
  })