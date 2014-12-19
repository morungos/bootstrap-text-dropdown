(($, window, document) ->

  'use strict'

  Textdropdown = (element, options) ->
    this.widget = ''
    this.$element = $(element)
    this.isOpen = options.isOpen
    this.orientation = options.orientation
    this.container = options.container
    @_init()

  Textdropdown.prototype =

    constructor: Textdropdown

    _init: () ->
      self = @
      @.$element.on {
        'click.textdropdown': $.proxy(this.showWidget, this)
        'blur.textdropdown': $.proxy(this.blurElement, this)
      }

      @.$widget = $(@getTemplate()).on('click', $.proxy(@widgetClick, @))
      @.$widget.find('textarea').each () ->
        $(@).on {
          'click.textdropdown': () -> $(@).select()
          'keydown.textdropdown': $.proxy(self.widgetKeydown, self)
          'keyup.textdropdown': $.proxy(self.widgetKeyup, self)
        }

    blurElement: () ->
      @highlightedUnit = null
      @updateFromElementVal()

    clear: () ->
      @.$element.val('')


    elementKeydown: (e) ->
      @update()

    getTemplate: () ->
      "<div class='bootstrap-textdropdown-widget dropdown-menu'><textarea class='bootstrap-text-dropdown-body'></textarea></div>"

    getText: () ->
      @text

    hideWidget: () ->
      return if @isOpen == false

      @.$element.trigger {
        'type': 'hide.textdropdown'
        'text': {
          'value': this.getText()
        }
      }

      @.$widget.removeClass('open')

      $(document).off('mousedown.textdropdown, touchend.textdropdown')

      @isOpen = false
      @.$widget.detach()

    place : () ->
      return if @isInline

      widgetWidth = @.$widget.outerWidth()
      widgetHeight = @.$widget.outerHeight()
      visualPadding = 10
      windowWidth = $(window).width()
      windowHeight = $(window).height()
      scrollTop = $(window).scrollTop()

      zIndex = parseInt(@.$element.parents().first().css('z-index'), 10) + 10
      offset = if @component then @.omponent.parent().offset() else @.$element.offset()
      height = if @component then @component.outerHeight(true) else @.$element.outerHeight(false)
      width = if @component then @component.outerWidth(true) else @.$element.outerWidth(false)
      left = offset.left
      top = offset.top

      @.$widget.removeClass('textdropdown-orient-top textdropdown-orient-bottom textdropdown-orient-right textdropdown-orient-left')

      if @orientation.x != 'auto'
        @picker.addClass('textdropdown-orient-' + this.orientation.x)
        if @orientation.x == 'right'
          left -= widgetWidth - width
      else
        @.$widget.addClass('textdropdown-orient-left')
        if offset.left < 0
          left -= offset.left - visualPadding
        else if offset.left + widgetWidth > windowWidth
          left = windowWidth - widgetWidth - visualPadding

      yorient = @.orientation.y
      topOverflow = undefined
      bottomOverflow = undefined

      if yorient == 'auto'
        topOverflow = -scrollTop + offset.top - widgetHeight
        bottomOverflow = scrollTop + windowHeight - (offset.top + height + widgetHeight)
        if Math.max(topOverflow, bottomOverflow) == bottomOverflow
          yorient = 'top'
        else
          yorient = 'bottom'

      @.$widget.addClass('textdropdown-orient-' + yorient)
      if yorient == 'top'
        top += height
      else
        top -= widgetHeight + parseInt(this.$widget.css('padding-top'), 10)

      @.$widget.css {
        top : top
        left : left
        zIndex : zIndex
      }

    remove: () ->
      $('document').off('.textdropdown')
      if @.$widget
        @.$widget.remove()
      delete @.$element.data().textdropdown

    setText: (text, ignoreWidget) ->
      if !text
        @clear()
        return

      @text = text
      @update(ignoreWidget)

    showWidget: (e) ->
      e.preventDefault()
      return if @isOpen
      return if @.$element.is(':disabled')


      @.$widget.appendTo(this.container)
      self = @;
      $(document).on 'mousedown.textdropdown, touchend.textdropdown', (e) ->
        self.hideWidget() if !(self.$element.parent().find(e.target).length || self.$widget.is(e.target) || self.$widget.find(e.target).length)

      @.$element.trigger {
        'type': 'show.textdropdown',
        'text': {
          'value': this.getText()
        }
      }

      @place()
      @.$element.blur()

      @.$widget.addClass('open') if @isOpen == false
      @.$widget.find("textarea").focus()
      @isOpen = true

    update: (ignoreWidget) ->
      @updateElement()
      this.updateWidget() if !ignoreWidget

    updateElement: () ->
      @.$element.val(@getText()).change()

    updateFromElementVal: () ->
      @setText(@.$element.val())

    updateWidget: () ->
      return if (@.$widget == false) 

      text = @text;
      @.$widget.find('.bootstrap-text-dropdown-body').val(text)

    updateFromWidgetInputs: () ->
      return if @.$widget == false

      t = @.$widget.find('.bootstrap-text-dropdown-body').val()
      @setText(t, true)

    widgetClick: (e) ->
      e.stopPropagation()
      e.preventDefault()

      $input = $(e.target)
      action = $input.closest('a').data('action')

      if action
        @[action]()
      @update()

    widgetKeyup: (e) ->
      @updateFromWidgetInputs()


  $.fn.textdropdown = (option) ->
    args = Array.apply(null, arguments)
    args.shift()
    @each () ->
      $this = $(@)
      data = $this.data('textdropdown')
      options = typeof option == 'object' && option

      if !data
        $this.data('textdropdown', (data = new Textdropdown(this, $.extend({}, $.fn.textdropdown.defaults, options, $(this).data()))))

      if typeof option == 'string'
        data[option].apply(data, args)


  $.fn.textdropdown.defaults =
    isOpen: false
    orientation: { x: 'auto', y: 'auto'}
    container: 'body'

  $.fn.textdropdown.Constructor = Textdropdown


) jQuery, window, document

