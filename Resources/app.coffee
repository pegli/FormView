
FormView = require 'FormView'

win = Ti.UI.createWindow()

def = [
  {
    title: 'Empty Section'
  }
  {
    title: 'Strings'
    fields: [
      { key: 'string1' }
      { key: 'string2', label: 'string', type: FormView.fieldTypes.STATIC }
      { key: 'string3', label: 'string from fn' }
      { key: 'string4', label: 'string_label' }
      { key: 'string5.sub1.sub2', label: 'dot notation' }
    ]
  }
  {
    title: 'Text'
    fields: [
      { key: 'text1', type: FormView.fieldTypes.TEXT, label: 'text' }
      { key: 'text2', type: FormView.fieldTypes.TEXT, options: { autocapitalization: Ti.UI.TEXT_AUTOCAPITALIZATION_WORDS } }
      { key: 'text3', type: FormView.fieldTypes.TEXT, label: 'async' }
      { key: 'text4', type: FormView.fieldTypes.EMAIL, label: 'email', value: 'user@example.com' }
      { key: 'text5', type: FormView.fieldTypes.PASSWORD, label: 'password' }
      { key: 'text6', type: FormView.fieldTypes.NUMBER, label: 'number' }
      { key: 'text7', type: FormView.fieldTypes.URL, label: 'url' }
    ]
  }
  {
    title: 'Pickers'
    fields: [
      { key: 'picker1', type: FormView.fieldTypes.DATE, label: 'date', dateFormat: 'short' }
      { key: 'picker2', type: FormView.fieldTypes.TIME, label: 'time' }
      { key: 'picker3', type: FormView.fieldTypes.DATETIME, label: 'date and time' }
    ]
  }
]


model = 
  string1: 'This is a plain string'
  string2: 'Another string'
  string3: (cb) ->
    cb(String.formatDate(new Date(), 'short'))
  string4: 'localized label'
  string5:
    sub1:
      sub2: 'dot notation string'
  
  text1: 'some freeform text'
  text2: 'text without label'
  text3: (cb) ->
    setTimeout(() ->
      cb 'delayed value'
    , 5000
    )
  text4: 'user@example.com'
  text6: 1
  text7: 'http://www.example.com/'
  
  picker1: new Date(2012, 4, 14)
  picker2: new Date(2012, 4, 14, 10, 12)
  picker3: new Date()

form = new FormView def
form.addEventListener 'FormView:change', (e) ->
  Ti.API.info "field #{e.name} changed to #{e.value}"
 
win.add form

win.addEventListener 'open', (e) ->
  Ti.API.info 'about to call populate'
  form.populate model

win.open()
