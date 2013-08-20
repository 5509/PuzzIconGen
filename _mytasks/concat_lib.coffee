module.exports = (grunt) ->

  grunt.loadNpmTasks('grunt-contrib-concat')

  grunt.config.set('dirs', {
    libSrc: '_sources/scripts/lib/'
    appSrc: '_sources/scripts/tmp/'
  })

  grunt.config.set('concat', {
    lib: {
      src: [
        '<%= dirs.libSrc %>jquery-2.0.3.min.js'
        '<%= dirs.libSrc %>underscore-min.js'
        '<%= dirs.libSrc %>backbone-min.js'
      ]
      dest: 'scripts/lib.js'
    }
    app: {
      src: ['<%= dirs.appSrc %>*.js']
      dest: 'scripts/app.js'
    }
  })