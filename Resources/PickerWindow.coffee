###
$Id$
(c) 2012 Paul Mietz Egli

Modal window for displaying a picker, adapted from
https://github.com/appcelerator-developer-relations/Forging-Titanium/blob/master/ep-010

For now, only supports a single column for non-datetime pickers.
###

class PickerWindow
  constructor: (options) ->
    options or= {}
    type = options.type or Ti.UI.PICKER_TYPE_PLAIN
    
    # ANDROID: call picker.showDatePickerDialog for dates
    # or set useSpinner = true to enable non-native spinner control
    
    result = Ti.UI.createWindow
      backgroundColor: 'transparent'
    
    overlay = Ti.UI.createView
      backgroundColor: 'black'
      opacity: 0.6
    
    container = Ti.UI.createView
      bottom: 0
      layout: 'vertical'
      height: 'auto'
    
    picker = Ti.UI.createPicker
      type: type
      height: 'auto'
      selectionIndicator: true
    
    switch type
      when Ti.UI.PICKER_TYPE_DATE, Ti.UI.PICKER_TYPE_TIME, Ti.UI.PICKER_TYPE_DATE_AND_TIME 
        picker.minDate = options.minDate
        picker.maxDate = options.maxDate
        picker.value = options.value or new Date()
      else
        data = for row in options.rows
          opts = if row instanceof String
            title: row
          else row
          Ti.UI.createTableViewRow opts
    
    done = Ti.UI.createButton
      title: L 'PickerWindow_done', 'Done'
    done.addEventListener 'click', (e) ->
      result.fireEvent 'PickerWindow:change',
        value: picker.value or picker.getSelectedRow(0).title
      result.close()
    
    cancel = Ti.UI.createButton
      title: L 'PickerWindow_cancel', 'Cancel'
    cancel.addEventListener 'click', (e) ->
      result.close()
    
    toolbar = if Ti.Platform.osname == 'android'
      Ti.UI.createView()
    else
      spacer = Ti.UI.createButton
        systemButton: Ti.UI.iPhone.SystemButton.FLEXIBLE_SPACE
      Ti.UI.iOS.createToolbar
        items: [cancel, spacer, done]
    
    container.add toolbar
    container.add picker
    result.add overlay
    result.add container
    
    return result

module.exports = PickerWindow