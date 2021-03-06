define ['./module'], ->

  App.module "Authentication", (Module, App, Backbone, Marionette, $, _) ->

    class Module.Model extends Backbone.Model

      url: "authentication/sign-in"

      defaults:
        username: ""
        password: ""

#      validation:
#        username:
#          required: true
#          containsOnlyLettersNumbersUnderscores: {}
#          rangeLength: [3, 20]
#        password:
#          required: true
#          containsUpperCaseLetter: {}
#          containsLowerCaseLetter: {}
#          containsNumber: {}
#          rangeLength: [6, 20]
#          notEqualTo: 'username'

    Module.on 'start', ->
      user = new Module.Model()
      Module.options.user = user
      return

    return

  return
