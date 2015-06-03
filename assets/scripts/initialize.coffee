define [
  'backbone'
  'backbone.marionette'
  'jquery'
  'underscore'
  'toastr'
  'select2'
  'metronic'
  'layout'
  'quick-sidebar'
  'demo'
  'moment'
  'iCheck'
  'backbone.paginator'
  'bootstrap-datetimepicker'
  'backbone.radio'
  'backbone.stickit'
  'backbone.picky'
  'backbone.radio.shim'
  'backbone.modals'
  'runtime'
  'bootstrap'
  'bootstrap-growl'
  'jquery-ui'
  'jquery-cookie'
  'datatables'
  'datatables-bootstrap'
  'backstretch'
  'amcharts'
  'pieChart'
  './behaviors/validation'
  './behaviors/textarea-supporting-tabs'
], (Backbone, Marionette, $, _, toastr, select2, metronic, layout,
    quickSidebar, demo, moment, iCheck) ->

  window.toastr = toastr
  window.moment = moment

  #init metronic theme
  window.initMetronic = ()->
    Metronic.init()
    Layout.init()
    Demo.init()


  Backbone.Marionette.Renderer.render = (template, data) ->
    Marionette.TemplateCache.get(template)(data)

  Backbone.Marionette.TemplateCache.prototype.compileTemplate = (rawTemplate) ->
    rawTemplate

  Backbone.Marionette.TemplateCache.prototype.loadTemplate = (template) ->
    template

  _.extend Backbone.Model.prototype, Backbone.Validation.mixin

  Backbone.Validation.configure forceUpdate: true

  _.mixin capitalize: (string) ->
    string.charAt(0).toUpperCase() + string.substring(1).toLowerCase()

  ((old) ->

    $.fn.attr = ->
      if arguments.length == 0
        if @length == 0
          return null
        obj = {}
        $.each @[0].attributes, ->
          if @specified
            obj[@name] = @value
          return
        return obj
      old.apply this, arguments

    return
  ) $.fn.attr
