$           = require('jquery')
Backbone    = require('backbone')
Backbone.$  = $
Marionette  = require('backbone.marionette')

Marionette = require './marionette_browserify'

Authentication  = require('./modules/authentication/module');
AppLayout       = require('./layout');

app = new Marionette.Application()
new AppLayout().render()
app.module('Authentication', Authentication)
app.start()
Backbone.history.start()


module.exports = app
