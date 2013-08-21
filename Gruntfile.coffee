module.exports = (grunt) ->

  grunt.task.loadTasks('_mytasks')
  grunt.loadNpmTasks('grunt-contrib-watch')

  # watch
  grunt.config.set('watch', {
    sass: {
      files: ['_sources/styles/*.scss']
      tasks: ['sass']
    }
    coffee: {
      files: ['_sources/scripts/coffee/**']
      tasks: ['coffee','concat','clean']
    }
  })

  # default
  grunt.registerTask('default', [
    'sass'
    'coffee'
    'concat'
    'clean'
  ])