module.exports = (grunt) ->

  grunt.loadNpmTasks('grunt-contrib-clean')
  grunt.config.set('clean', [
    '_sources/scripts/tmp'
  ])