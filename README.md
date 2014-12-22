bootstrap-text-dropdown
=======================

A dropdown text editor that can be used to open a small cell into a bigger text editor


Documentation
-------------

Start the text dropdown using JavaScript:

```
$('.my-input').textdropdown({ /*options...*/ });
```


Options
-------

Name          | Type          | Default     | Description
------------- | ------------- | ----------- | -----------
container     | string        | body        | The dropdown will be contained inside this element, defaulting to the document body.


Methods
-------

Method                | Description
--------------------- | -----------
`showWidget()`        | Opens the dropdown unless it is currently open.
`hideWidget()`        | Closes the dropdown if it is currently open.


Events
-------

Event                 | Description
--------------------- | -----------
`show.textdropdown`   | Fires when the dropdown is opened. The event's `text` property contains the current text.
`hide.textdropdown`   | Fires when the dropdown is hidden or closed. The event's `text` property contains the current text.
`keyup.textdropdown`  | Fires when a key is pressed in the dropdown. The event's `text` property contains the current text, and the event's `originalEvent` contains the original event data, including the key code.
