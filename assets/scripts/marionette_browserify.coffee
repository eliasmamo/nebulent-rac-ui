((root, factory) ->
  $ = require('jquery')
  Backbone = require('backbone')
  Backbone.$ = $
  Marionette = require('backbone.marionette')
  Radio = require('backbone.radio')
  _ = require('underscore')
  module.exports = factory(Marionette, Radio, _)
  return
) this, (Marionette, Radio, _) ->
  'use strict'

  Marionette.Application::_initChannel = ->
    @channelName = _.result(this, 'channelName') or 'global'
    @channel = _.result(this, 'channel') or Radio.channel(@channelName)
    return

  return
Marionette = require('backbone.marionette')
module.exports = Marionette
