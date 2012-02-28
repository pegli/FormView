
FormView = require 'FormView'

win = Ti.UI.createWindow()

def = [
  {
    title: 'Strings'
    fields: [
      { name: 'string1', value: 'This is a plain string' }
      { name: 'string2', label: 'string', value: 'Another string', type: FormView.fieldTypes.STATIC }
      { name: 'string3', label: 'string from fn', value: () ->
        return String.formatDate(new Date(), 'short')
      }
      { name: 'string4', label: 'string_label', value: 'localized label' }
    ]
  }
  {
    title: 'Text'
    fields: [
      { name: 'text1', type: FormView.fieldTypes.TEXT, label: 'text', value: 'some freeform text' }
      { name: 'text2', type: FormView.fieldTypes.TEXT, value: 'text without label' }
    ]
  }
]

form = new FormView def
  
 
win.add form
win.open()
