module.exports = (grunt) ->

  grunt.task.loadTasks('_mytasks')
  grunt.loadNpmTasks('grunt-contrib-watch')

  grunt.config.set('watch', {
    sass: {
      files: ['_sources/styles/*.scss']
      tasks: ['sass']
    }
    coffee: {
      files: ['_sources/scripts/coffee/*.coffee']
      tasks: ['coffee']
    }
  })
  grunt.registerTask('default', [
    'concat'
    'sass'
    'coffee'
  ])