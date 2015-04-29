Marionette = require 'backbone.marionette'

class Authentication extends Marionette.Module
  startWithParent:  true
  getOption:        Marionette.proxyGetOption
  options:          {}


module.exports = Authentication
