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
    label:
      width: 21
      color: '#405080'
      font:
        fontSize: '12dp'
        fontWeight: 'bold'
    value:
      font:
        fontSize: '16dp'
        fontWeight: 'bold'
        
  
  createSection: (def) ->
    result = Ti.UI.createTableViewSection
      headerTitle: def.title
      
    fields = def.fields or []
    result.add @createFieldRow field for field in fields
    
    return result
  
  fetchFieldValue: (def) ->
    if not def?.value
      return null
      
    if typeof def.value == 'function'
      return def.value()
    else
      return def.value

  createFieldRow: (def) ->
    result = Ti.UI.createTableViewRow()
    
    input = switch def.type
      when FormView.fieldTypes.TEXT, FormView.fieldTypes.EMAIL, FormView.fieldTypes.PASSWORD, FormView.fieldTypes.NUMBER, FormView.fieldTypes.URL
        @buildTextInput def, result
      else @buildLabelInput def, result
    
    left = parseInt @style.padding
    if def.label
      result.add Ti.UI.createLabel
        left: "#{@style.padding}%"
        width: "#{@style.label.width}%"
        top: "#{@style.padding}%"
        bottom: "#{@style.padding}%"
        text: L def.label, def.label
        font: @style.label.font
        color: @style.label.color
        textAlign: 'right'
      left += @style.label.width + @style.padding

    input.left = "#{left}%"
    result.add input    
    
    return result
  
  buildLabelInput: (def, row) ->
    Ti.UI.createLabel
      right: "#{@style.padding}%"
      top: "#{@style.padding}%"
      bottom: "#{@style.padding}%"
      font: @style.value.font
      text: @fetchFieldValue def
  
  buildTextInput: (def, row) ->
    result = Ti.UI.createTextField
      left: "#{@style.padding}%"
      right: "#{@style.padding}%"
      top: "#{@style.padding}%"
      bottom: "#{@style.padding}%"
      font: @style.value.font
      borderStyle: Ti.UI.INPUT_BORDERSTYLE_ROUNDED
      keyboardType: Ti.UI.KEYBOARD_DEFAULT
      value: @fetchFieldValue def
    
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