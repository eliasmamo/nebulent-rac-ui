define [
  './templates/extend-rent-agreement-modal-template'
],  (template) ->

  App.module "CarRentAgreement", (Module, App, Backbone, Marionette, $, _) ->

    class Module.ExtendRentAgreementModal extends Marionette.ItemView
      className: "modal-dialog"
      template: template
      saving: false
      maximumDays: 14
      minimumDays: 1

      ui:
        days:             "[name='days']"
        newDueDate:       "[name=dueDate]"

      bindings:
        'input[name="daily_rate"]'         : observe: 'dailyRate'
        'input[name="dueDate"]'            :
          observe: 'dueDate'
          onGet: (value)-> moment.unix(parseInt(value)/1000).format(App.DataHelper.dateFormats.us)
          onSet: (value)-> moment(value, App.DataHelper.dateFormats.us).unix()*1000
        'input[name="days"]'               : observe: 'days'
        'input[name="total"]'              : observe: 'total'
        'input[name="discount_rate"]'      : observe: 'discountRate'
        'input[name="amount_paid"]'        : observe: 'amountPaid'

      events:
        "change @ui.days":          "onDaysCountChange"
        "dp.change @ui.newDueDate": "onDueDateChange"
        "change @ui.newDueDate":    "onDueDateChange"
        "click .extend":            "onExtendClick"

      initialize: (options)->
        @originalModel = options.originalModel
        minDate = new Date moment.unix(parseInt(@originalModel.get('dueDate'))/1000).format(App.DataHelper.dateFormats.us)
        minDate.setDate minDate.getDate() + 1
        @minDate = moment(minDate).format(App.DataHelper.dateFormats.us)
        @dueDate = moment.unix(parseInt(@originalModel.get('dueDate'))/1000).format(App.DataHelper.dateFormats.us)

        @model.set 'status', 'EXTENDED'
        @model.set 'days', '1'
        @model.set 'amountPaid', '0'

        @listenTo @model, 'change:days',          @refreshModel
        @listenTo @model, 'change:discountRate',  @refreshModel
        @listenTo @model, 'change:dailyRate',     @refreshModel
        @listenTo @model, 'change:amountPaid',    @refreshModel
        @listenTo @model, 'change:total',         @refreshModel

      refreshModel: (model, value, event)->
        return @model.recalcPaidAndDue() if event?.stickitChange?.observe in ['total', 'amountPaid']
        @model.recalcAll()

      onShow: ->
        @stickit()
        @$el.closest('.modal').on 'shown.bs.modal',   => @initElements()
        @$el.closest('.modal').on 'hidden.bs.modal',  => @destroy()

      initElements: ->
        @ui.newDueDate.val @minDate
        @ui.newDueDate.datetimepicker
          format:      App.DataHelper.dateFormats.us
          minDate:     @minDate
        @model.recalcAll()

      onDueDateChange: ->
        if moment(@ui.newDueDate.val()).unix() > moment(@dueDate).unix()
          dateDifference = @getDaysDifference @ui.newDueDate.val(), @dueDate
          if dateDifference > 0
            @model.set 'days', dateDifference
          else
            @ui.newDueDate.val @minDate
          @newDueDate = @ui.newDueDate.val()
        else
          @model.set 'days', @minDate
          @newDueDate = @ui.newDueDate.val()

      getDaysDifference: (date1, date2)->
        date1 = new Date date1
        date2 = new Date date2
        timeDiff = Math.abs(date2.getTime() - date1.getTime());
        Math.ceil(timeDiff / (1000 * 3600 * 24));

      onDaysCountChange: (e)->
        dayCount = parseInt($(e.currentTarget).val())
        @ui.days.val dayCount + 1 if dayCount <= 0
        @ui.newDueDate.val @addDays(@dueDate, @ui.days.val())
        @dayCount = @ui.days.val()

      addDays: (date, days)->
        date = new Date date
        date.setDate date.getDate() + parseInt(days)
        moment(date).format(App.DataHelper.dateFormats.us)

      onExtendClick: ->
        return if saving
        saving = true
        @calculateAndSave()

      calculateAndSave: ->
        unless @model.get "amountPaid"
          toastr.error "Please fill the amount paid field"
          return false
        @model.get('deposit').set 'status', 'ARCHIVED'
        #TODO: think of the way to avoid this kind of nulling
        @model.set 'amountDue', undefined
        @model.set 'dueDate', undefined
        @model.save()
          .success =>
            toastr.success "Successfully Extended Agreement"
            @originalModel.fetch(parse: true)
            @originalModel.collection.trigger('change')
            @$('.close').click()
          .error   =>
            toastr.error "Error Extending Agreement"

      destroy: ->
        @$el.closest('.modal').off 'shown.bs.modal'
        @$el.closest('.modal').off 'hidden.bs.modal'
        super

  App.CarRentAgreement.ExtendRentAgreementModal
