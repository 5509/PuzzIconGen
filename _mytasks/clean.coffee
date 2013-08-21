module.exports = (grunt) ->

  grunt.loadNpmTasks('grunt-contrib-clean')
  grunt.config.set('clean', [
    'scripts/tmp'
  ])