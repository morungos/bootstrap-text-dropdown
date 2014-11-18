jsdom = require 'jsdom'

describe 'My Plugin', () ->

  $ = undefined

  beforeEach (done) ->
    jsdom.env
      html: '<html><body></body></html>'
      scripts: ['../../.tmp/vendors/jquery.js', '../js/bootstrap-text-dropdown.js']
      done: (err, window) ->
        if err then console.log(err)
        $ = window.jQuery
        done()

  it 'should add the class "classy" to the element', () ->
    el = $('<div></div>').showLinkLocation()
    expect(el.hasClass('classy')).toBe(true)
