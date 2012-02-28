
FormView = require 'FormView'

win = Ti.UI.createWindow()

def = [
  {
    title: 'Empty Section'
  }
  {
    title: 'Strings'
    fields: [
      { name: 'string1', value: 'This is a plain string' }
      { name: 'string2', label: 'string', value: 'Another string', type: FormView.fieldTypes.STATIC }
      { name: 'string3', label: 'string from fn', value: (cb) ->
        cb(String.formatDate(new Date(), 'short'));
      }
      { name: 'string4', label: 'string_label', value: 'localized label' }
    ]
  }
  {
    title: 'Text'
    fields: [
      { name: 'text1', type: FormView.fieldTypes.TEXT, label: 'text', value: 'some freeform text' }
      { name: 'text2', type: FormView.fieldTypes.TEXT, value: 'text without label', options: { autocapitalization: Ti.UI.TEXT_AUTOCAPITALIZATION_WORDS } }
      {
        name: 'text3', type: FormView.fieldTypes.TEXT, label: 'async', value: (cb) ->
          setTimeout(() ->
            cb 'delayed value'
          , 5000
          )
      }
      { name: 'text4', type: FormView.fieldTypes.EMAIL, label: 'email', value: 'user@example.com' }
      { name: 'text5', type: FormView.fieldTypes.PASSWORD, label: 'password' }
      { name: 'text6', type: FormView.fieldTypes.NUMBER, label: 'number', value: 1 }
      { name: 'text7', type: FormView.fieldTypes.URL, label: 'url', value: 'http://www.example.com/' }
    ]
  }
]

form = new FormView def
form.addEventListener 'FormView:change', (e) ->
  Ti.API.info "field #{e.name} changed to #{e.value}"
 
win.add form
win.open()
