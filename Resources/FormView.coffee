###
$Id$
(c) 2012 Paul Mietz Egli

Cross-platform data form view
###

is_android = Ti.Platform.osname == 'android'
PickerWindow = require './PickerWindow'

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

    result.populate = (model) ->
      # TODO dot-notation for keys
      for k of result.setterMap
        s = result.setterMap[k]
        v = model[k]
        if s and v
          if v instanceof Function
            v(s)
          else
            s(v)

    return result
  
  @fieldTypes: {}
  
  @keyboardMap: {}

  
# static initialization of FormView class members
  
FormView.fieldTypes =   
  STATIC: 1
  TEXT: 2
  EMAIL: 3
  PASSWORD: 4
  NUMBER: 5
  URL: 6
  DATE: 7
  TIME: 8
  DATETIME: 9
    
FormView.keyboardMap[FormView.fieldTypes.TEXT] = Ti.UI.KEYBOARD_DEFAULT
FormView.keyboardMap[FormView.fieldTypes.EMAIL] = Ti.UI.KEYBOARD_EMAIL
FormView.keyboardMap[FormView.fieldTypes.PASSWORD] = Ti.UI.KEYBOARD_DEFAULT
FormView.keyboardMap[FormView.fieldTypes.NUMBER] = Ti.UI.KEYBOARD_NUMBERS_PUNCTUATION
FormView.keyboardMap[FormView.fieldTypes.URL] = Ti.UI.KEYBOARD_URL


class GroupedTableFormView
  constructor: (sections) ->
    result = Ti.UI.createTableView
      style: Ti.UI.iPhone.TableViewStyle.GROUPED

    result.setterMap = {}
    result.addSetter = (k, v) ->
      if k and v
        m = result.setterMap
        m[k] = v
        result.setterMap = m
      
    data = (@createSection result, section for section in sections)
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
      clearButtonMode: Ti.UI.INPUT_BUTTONMODE_ONFOCUS
      keyboardType: Ti.UI.KEYBOARD_DEFAULT
      font:
        fontSize: '16dp'

  
  createSection: (parent, def) ->
    result = Ti.UI.createTableViewSection
      headerTitle: def.title
      
    fields = def.fields or []
    result.add @createFieldRow parent, field for field in fields
    
    return result
  
  createFieldRow: (parent, def) ->
    if not def.key
      throw "missing required property 'key' in field definition: #{def}"
      
    result = Ti.UI.createTableViewRow
      eventTarget: parent
    
    [control, setter] = switch def.type
      when FormView.fieldTypes.TEXT, FormView.fieldTypes.EMAIL, FormView.fieldTypes.PASSWORD, FormView.fieldTypes.NUMBER, FormView.fieldTypes.URL
        @buildTextInput def, result
      when FormView.fieldTypes.DATE, FormView.fieldTypes.TIME, FormView.fieldTypes.DATETIME
        @buildPickerInput def, result
      else
        @buildLabelInput def, result
    
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

    control.left = "#{left}%"

    parent.addSetter(def.key, setter)
    result.add control
    
    return result
  
  ###
  Static text fields
  ###
  buildLabelInput: (def, row) ->
    options = def.options or {}
    opts = merge @style.STATIC, options,
      right: "#{@style.padding}%"
      top: "#{@style.padding}%"
      bottom: "#{@style.padding}%"
    result = Ti.UI.createLabel opts
    
    setter = (v) ->
      result.text = if def.formatter then def.formatter(v) else v
      
    [result, setter]
  
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
    options = def.options or {}
    opts = merge @style.TEXT, options,
      name: def.name
      left: "#{@style.padding}%"
      right: "#{@style.padding}%"
      top: "#{@style.padding}%"
      bottom: "#{@style.padding}%"
    result = Ti.UI.createTextField opts
    result.keyboardType or= FormView.keyboardMap[def.type]
    result.keyboardToolbar or= @buildKeyboardToolbar result
    result.addEventListener 'change', (e) ->
      row.eventTarget.fireEvent 'FormView:change',
        name: e.source.name
        value: e.value

    switch def.type
      when FormView.fieldTypes.PASSWORD
        result.passwordMask = true

    setter = (v) ->
      result.value = if def.formatter then def.formatter(v) else v

    [result, setter]
  
  ###
  Date picker drawers
  ###
  
  buildPickerInput: (def, row) ->
    [result, setter] = @buildLabelInput def, row
    [result, null]
    
   


class ScrollFormView
  constructor: () ->
    result = Ti.UI.createScrollView()
    return result

module.exports = FormView