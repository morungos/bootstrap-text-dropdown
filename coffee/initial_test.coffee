jsdom = require 'jsdom'
expect = require('chai').expect

describe 'textDropdown plugin', () ->

  $ = undefined

  document = undefined

  beforeEach (done) ->
    result = jsdom.env
      html: '<html><body></body></html>'
      scripts: ['../../.tmp/vendors/jquery.js', '../js/bootstrap-text-dropdown.js']
      done: (err, window) ->
        if err then console.log(err)
        $ = window.jQuery
        document = window.document
        done()

  it 'should be defined on jQuery object', () ->
    expect($.fn.textDropdown).to.exist

  it 'should return jQuery collection containing the element', () ->
    $el = $('<div/>')
    $dropdown = $el.textDropdown()
    expect($dropdown).to.be.an.instanceof($)
    expect($dropdown[0]).to.equal($el[0])
