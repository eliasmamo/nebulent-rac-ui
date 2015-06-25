define [
  './widget'
  './rental-dues-widget-item'
], (WidgetView, RentalDuesWidgetItem)->


  App.module "Dashboard", (Module, App, Backbone, Marionette, $, _) ->

    class Module.RentalDuesWidget extends WidgetView
      childView:    RentalDuesWidgetItem
      title:        'Active Rentals'
      dataTableId:  'rental_dues'
      headerItems:  ['#', 'Client Name', 'Vehicle Make', 'Vehicle Model', 'Vehicle Color', 'Vehicle Plate Number', 'Started On', 'Due Date', 'Actions']
      icon:         'fa-clock-o'
      color:        'red'

  App.Dashboard.RentalDuesWidget
