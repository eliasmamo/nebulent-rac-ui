Marionette = require 'backbone.marionette'

class LayoutView extends Marionette.LayoutView
  el: 'body'

  regions:
    main_region: '#main-region'

  onRender: ->
    console.log 'dsfsdf'


module.exports = LayoutView
