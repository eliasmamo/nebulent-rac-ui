define [
  './templates/customer-row-template'
], (template)->

  App.module "Customers", (Module, App, Backbone, Marionette, $, _) ->

    class Module.CustomerRowView extends Marionette.ItemView
      className: "item-view customer-row"
      tagName:   "tr"
      template:   template

      events:
        "click":               'onClick'
        "click .delete-row" :  'onCustomerRemove'

      bindings:
        ".item_status":
            observe:  "contactStatus"
            onGet:    "onStatusChange"

      templateHelpers: ->
        modelIndex: @index

      initialize: (options)->
        @index = options.index

      onClick: (e)->
        return if $(e.target).prop('tagName') in ["I", "A"]
        App.Router.navigate "#customer/#{@model.get('contactID')}", trigger: true

      onStatusChange: (value)->
        @$('.item_status').attr "class", "item_status #{value.toLowerCase()}"
        value

      onShow:->
        @stickit()
        @$el.addClass('deleted') if @model.get('contactStatus') is "DELETED"

      onCustomerRemove:->
        bootbox.confirm "Are you sure you want to delete this customer?", (result)=>
          return unless result
          previousStatus = @model.get('contactStatus')
          @model.set "contactStatus", "DELETED"
          @model.save()
            .success (data)=>
              @$el.addClass('deleted')
              @$('.actions').html ""
              toastr.success "Successfully deleted customer"
            .error   (data)=>
              toastr.error "Error deleting customer"
              @model.set "contactStatus", previousStatus

  App.Customers.CustomerRowView
