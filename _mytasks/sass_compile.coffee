module.exports = (grunt) ->

  grunt.loadNpmTasks('grunt-contrib-sass')

  grunt.config.set('sass', {
    dist: {
      files: [{
        expand: true
        cwd: '_sources/styles'
        src: ['*.scss']
        dest: 'styles'
        ext: '.css'
      }]
    }
  })