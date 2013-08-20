module.exports = (grunt) ->

  grunt.loadNpmTasks('grunt-contrib-concat')

  grunt.config.set('dirs', {
    src: '_sources/scripts/lib/'
  })

  grunt.config.set('concat', {
    dist: {
      src: [
        '<%= dirs.src %>jquery-2.0.3.min.js'
        '<%= dirs.src %>underscore-min.js'
        '<%= dirs.src %>backbone-min.js'
      ]
      dest: 'scripts/lib.js'
    }
  })