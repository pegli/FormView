# FormView Module

This Titanium CommonJS module provides a simple way to create data entry forms with
consistent style and functionality.  Forms are built from an array of form section
objects which define field types and values.

## Section

A form section is a group of related form fields.

<table>
  <tr>
    <th>property</th>
    <th>type</th>
    <th>req'd?</th>
    <th>description</th>
  </tr>
  <tr>
    <td>title</td>
    <td>String</td>
    <td>no</td>
    <td>A title to display above the form section</td>
  </tr>
  <tr>
    <td>fields</td>
    <td>Object[]</td>
    <td>no</td>
    <td>An array of field objects describing the form fields in this section</td>
  </tr>
</table>

## Field

A form field is a single input control and optional label.

<table>
  <tr>
    <th>property</th>
    <th>type</th>
    <th>req'd?</th>
    <th>description</th>
  </tr>
  <tr>
    <td>key</td>
    <td>String</td>
    <td>yes</td>
    <td>
      The name of the input value for this field.  This string is provided in the change
      event along with the updated field value. 
    </td>
  </tr>
  <tr>
    <td>label</td>
    <td>String</td>
    <td>no</td>
    <td>A string describing the field which will be displayed to the left of the field.</td>
  </tr>
  <tr>
    <td>formatter</td>
    <td>Function</td>
    <td>no</td>
    <td>
      Function which converts the model value to a string for display.  The function should take
      the "native" data format as a parameter and return a string.
    </td>
  </tr>
  <tr>
    <td>options</td>
    <td>Object</td>
    <td>no</td>
    <td>
      An object containing properties that override the default propeties of the form input control.
    </td>
  </tr>
</table>

## Data Model

The data model is a dictionary that is passed to the populate() method of the FormView to
place data into the form.  The dictionary values can be strings, numbers, or functions.