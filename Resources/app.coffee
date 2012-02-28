
FormView = require 'FormView'

win = Ti.UI.createWindow()

def = [
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
      { name: 'text2', type: FormView.fieldTypes.TEXT, value: 'text without label' }
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
    ]
  }
]

form = new FormView def
  
 
win.add form
win.open()
