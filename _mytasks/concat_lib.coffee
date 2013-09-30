module.exports = (grunt) ->

  grunt.loadNpmTasks('grunt-contrib-concat')

  grunt.config.set('dirs', {
    libSrc: '_sources/scripts/lib/'
    appSrc: '_sources/scripts/tmp/'
  })

  grunt.config.set('concat', {
    options: {
      seperator: ';'
    }
    lib: {
      src: [
        '<%= dirs.libSrc %>jquery-2.0.3.min.js'
        '<%= dirs.libSrc %>underscore-min.js'
        '<%= dirs.libSrc %>backbone-min.js'
        '<%= dirs.libSrc %>binaryajax.js'
        '<%= dirs.libSrc %>exif.js'
        '<%= dirs.libSrc %>megapix-image.js'
      ]
      dest: 'scripts/lib.js'
    }
    app: {
      src: [
        'scripts/tmp/app/*.js'
        'scripts/tmp/controller/base.js'
        'scripts/tmp/controller/app.js'
        'scripts/tmp/model/*.js'
        'scripts/tmp/collection/*.js'
        'scripts/tmp/view/app.js'
        'scripts/tmp/view/preview.js'
      ]
      dest: 'scripts/app.js'
    }
  })