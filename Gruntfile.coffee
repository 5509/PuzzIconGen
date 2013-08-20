module.exports = (grunt) ->

  grunt.task.loadTasks('_mytasks')

  grunt.registerTask('default', [
    'concat'
    'sass'
    'coffee'
  ])