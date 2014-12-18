(($) ->

  backdrop = '.text-dropdown-backdrop'
  toggle   = '[data-toggle="text-dropdown"]'
  Dropdown = (element) ->
    $(element).on('click.bs.text-dropdown', @toggle)

  Dropdown.VERSION = '3.3.1'

  Dropdown.prototype.toggle = (e) ->
    $this = $(@)

    return if $this.is('.disabled, :disabled')

    $parent  = getParent($this)
    isActive = $parent.hasClass('open')

    clearMenus()

    if !isActive
      if 'ontouchstart' in document.documentElement && !$parent.closest('.navbar-nav').length
        $('<div class="text-dropdown-backdrop"/>').insertAfter($(this)).on('click', clearMenus)

      relatedTarget = { relatedTarget: this }
      $parent.trigger(e = $.Event('show.bs.text-dropdown', relatedTarget))

      return if e.isDefaultPrevented()

      $this
        .trigger('focus')
        .attr('aria-expanded', 'true')

      $parent
        .toggleClass('open')
        .trigger('shown.bs.text-dropdown', relatedTarget)

    return false

  Dropdown.prototype.keydown = (e) ->
    return if !/(38|40|27|32)/.test(e.which) or /input|textarea/i.test(e.target.tagName)

    $this = $(this)

    e.preventDefault()
    e.stopPropagation()

    return if $this.is('.disabled, :disabled')

    $parent  = getParent($this)
    isActive = $parent.hasClass('open')

    if (!isActive and e.which != 27) or (isActive and e.which == 27)
      if e.which == 27 then $parent.find(toggle).trigger('focus')
      return $this.trigger('click')

    desc = ' li:not(.divider):visible a'
    $items = $parent.find('[role="menu"]' + desc + ', [role="listbox"]' + desc)

    return if !$items.length

    index = $items.index(e.target)

    if e.which == 38 and index > 0                    then index--                        ## up
    if e.which == 40 and index < $items.length - 1    then index++                        ## down
    if !~index                                        then index = 0

    $items.eq(index).trigger('focus')


  clearMenus = (e) ->
    return if e && e.which == 3 
    $(backdrop).remove()
    $(toggle).each () ->
      $this         = $(this)
      $parent       = getParent($this)
      relatedTarget = { relatedTarget: this }

      return if (!$parent.hasClass('open')) 

      $parent.trigger(e = $.Event('hide.bs.text-dropdown', relatedTarget))

      return if (e.isDefaultPrevented()) 

      $this.attr('aria-expanded', 'false')
      $parent.removeClass('open').trigger('hidden.bs.text-dropdown', relatedTarget)


  getParent = ($this) ->
    selector = $this.attr('data-target')

    if !selector
      selector = $this.attr('href')
      selector = selector and /#[A-Za-z]/.test(selector) and selector.replace(/.*(?=#[^\s]*$)/, '') ## strip for ie7

    $parent = selector and $(selector)

    return $parent and $parent.length ? $parent : $this.parent()


  ## DROPDOWN PLUGIN DEFINITION
  ## ==========================

  Plugin = (option) ->
    return @each () ->
      $this = $(@)
      data  = $this.data('bs.text-dropdown')

      if !data then $this.data('bs.text-dropdown', (data = new Dropdown(@)))
      if typeof option == 'string' then data[option].call($this)

  old = $.fn.textDropdown

  $.fn.textDropdown             = Plugin
  $.fn.textDropdown.Constructor = Dropdown


  ## DROPDOWN NO CONFLICT
  ## ====================

  $.fn.textDropdown.noConflict = () ->
    $.fn.dropdown = old
    return @


  ## APPLY TO STANDARD DROPDOWN ELEMENTS
  ## ===================================

  $(document)
    .on 'click.bs.text-dropdown.data-api', clearMenus
    .on 'click.bs.text-dropdown.data-api', '.dropdown form', (e) -> e.stopPropagation()
    .on 'click.bs.text-dropdown.data-api', toggle, Dropdown.prototype.toggle
    .on 'keydown.bs.text-dropdown.data-api', toggle, Dropdown.prototype.keydown
    .on 'keydown.bs.text-dropdown.data-api', '[role="menu"]', Dropdown.prototype.keydown
    .on 'keydown.bs.text-dropdown.data-api', '[role="listbox"]', Dropdown.prototype.keydown


) jQuery
