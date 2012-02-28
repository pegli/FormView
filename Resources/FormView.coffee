###
$Id$
(c) 2012 Paul Mietz Egli

Cross-platform data form view
###

###
[
  { title: 'General', fields: [ { label: 'type', type: 'select' } ] }
]
###

is_android = Ti.Platform.osname == 'android'

###
###
merge = (sources...) ->
  object = {}
  for src in sources
    for own key, val of src
      if not object[key]? or typeof val isnt "object"
        object[key] = val
      else
        object[key] = merge object[key], val
  object



class FormView
  constructor: (sections) ->
    sections or= []
    
    if is_android
      result = new ScrollFormView(sections)
    else
      result = new GroupedTableFormView(sections)

    return result
  
  @fieldTypes:
    STATIC: 1
    TEXT: 2
    EMAIL: 3
    PASSWORD: 4
    NUMBER: 5
    URL: 6
    


class GroupedTableFormView
  constructor: (sections) ->
    result = Ti.UI.createTableView
      style: Ti.UI.iPhone.TableViewStyle.GROUPED

    data = (@createSection section for section in sections)
    result.setData data

    return result
  
  # default style mimics the Contacts app
  style:
    padding: 4
    labelWidth: 21

    LABEL:
      textAlign: 'right'
      color: '#405080'
      font:
        fontSize: '12dp'
        fontWeight: 'bold'
    
    STATIC:
      font:
        fontSize: '16dp'
        fontWeight: 'bold'
        
    TEXT:
      borderStyle: Ti.UI.INPUT_BORDERSTYLE_ROUNDED
      keyboardType: Ti.UI.KEYBOARD_DEFAULT
      font:
        fontSize: '16dp'

  
  createSection: (def) ->
    result = Ti.UI.createTableViewSection
      headerTitle: def.title
      
    fields = def.fields or []
    result.add @createFieldRow field for field in fields
    
    return result
  
  ###
  Call the provided input control setter method with the value of
  the field.  If def.value is a function, invoke that function, passing
  the setter method as a callback; otherwise, invoke the setter with
  the value of def.value.
  ###
  fetchFieldValue: (def, setter) ->
    if not def?.value
      setter null
      
    if typeof def.value == 'function'
      def.value setter
    else
      setter def.value


  createFieldRow: (def) ->
    result = Ti.UI.createTableViewRow()
    
    input = switch def.type
      when FormView.fieldTypes.TEXT, FormView.fieldTypes.EMAIL, FormView.fieldTypes.PASSWORD, FormView.fieldTypes.NUMBER, FormView.fieldTypes.URL
        @buildTextInput def, result
      else @buildLabelInput def, result
    
    left = parseInt @style.padding
    if def.label
      opts = merge @style.LABEL,
        left: "#{@style.padding}%"
        width: "#{@style.labelWidth}%"
        top: "#{@style.padding}%"
        bottom: "#{@style.padding}%"
        text: L def.label, def.label

      result.add Ti.UI.createLabel opts
      left += @style.labelWidth + @style.padding

    input.left = "#{left}%"
    result.add input    
    
    return result
  
  ###
  Static text fields
  ###
  buildLabelInput: (def, row) ->
    opts = merge @style.STATIC,
      right: "#{@style.padding}%"
      top: "#{@style.padding}%"
      bottom: "#{@style.padding}%"
    result = Ti.UI.createLabel opts
    @fetchFieldValue def, result.setText
    result
  
  ###
  Single-line text entry fields
  ###
  
  buildKeyboardToolbar: (textfield) ->
    done = Ti.UI.createButton
      systemButton: Ti.UI.iPhone.SystemButton.DONE
      
    done.addEventListener 'click', (e) ->
      textfield.blur()
    
    spacer = Ti.UI.createButton
      systemButton: Ti.UI.iPhone.SystemButton.FLEXIBLE_SPACE
    
    textfield._done_button_ref = done # WORKAROUND: TIMOB-5066
    return [spacer, done]


  buildTextInput: (def, row) ->
    opts = merge @style.TEXT,
      left: "#{@style.padding}%"
      right: "#{@style.padding}%"
      top: "#{@style.padding}%"
      bottom: "#{@style.padding}%"
    result = Ti.UI.createTextField opts
    result.keyboardToolbar = @buildKeyboardToolbar result
    @fetchFieldValue def, result.setValue

    switch def.type
      when FormView.fieldTypes.PASSWORD
        result.passwordMask = true
        result.keyboardType = Ti.UI.KEYBOARD_DEFAULT
      when FormView.fieldTypes.EMAIL
        result.keyboardType = Ti.UI.KEYBOARD_EMAIL
      when FormView.fieldTypes.NUMBER
        result.keyboardType = Ti.UI.KEYBOARD_NUMBERS_PUNCTUATION
      when FormView.fieldTypes.URL
        result.keyboardType = Ti.UI.KEYBOARD_URL

    result
   


class ScrollFormView
  constructor: () ->
    result = Ti.UI.createScrollView()
    return result

module.exports = FormView