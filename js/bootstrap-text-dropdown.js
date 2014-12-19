(function($, window, document) {
  'use strict';
  var Textdropdown;
  Textdropdown = function(element, options) {
    this.widget = '';
    this.$element = $(element);
    this.isOpen = options.isOpen;
    this.orientation = options.orientation;
    this.container = options.container;
    return this._init();
  };
  Textdropdown.prototype = {
    constructor: Textdropdown,
    _init: function() {
      var self;
      self = this;
      this.$element.on({
        'click.textdropdown': $.proxy(this.showWidget, this),
        'blur.textdropdown': $.proxy(this.blurElement, this)
      });
      this.$widget = $(this.getTemplate()).on('click', $.proxy(this.widgetClick, this));
      return this.$widget.find('textarea').each(function() {
        return $(this).on({
          'click.textdropdown': function() {
            return $(this).select();
          },
          'keydown.textdropdown': $.proxy(self.widgetKeydown, self),
          'keyup.textdropdown': $.proxy(self.widgetKeyup, self)
        });
      });
    },
    blurElement: function() {
      this.highlightedUnit = null;
      return this.updateFromElementVal();
    },
    clear: function() {
      return this.$element.val('');
    },
    elementKeydown: function(e) {
      return this.update();
    },
    getTemplate: function() {
      return "<div class='bootstrap-textdropdown-widget dropdown-menu'><textarea class='bootstrap-text-dropdown-body'></textarea></div>";
    },
    getText: function() {
      return this.text;
    },
    hideWidget: function() {
      if (this.isOpen === false) {
        return;
      }
      this.$element.trigger({
        'type': 'hide.textdropdown',
        'text': {
          'value': this.getText()
        }
      });
      this.$widget.removeClass('open');
      $(document).off('mousedown.textdropdown, touchend.textdropdown');
      this.isOpen = false;
      return this.$widget.detach();
    },
    place: function() {
      var bottomOverflow, height, left, offset, scrollTop, top, topOverflow, visualPadding, widgetHeight, widgetWidth, width, windowHeight, windowWidth, yorient, zIndex;
      if (this.isInline) {
        return;
      }
      widgetWidth = this.$widget.outerWidth();
      widgetHeight = this.$widget.outerHeight();
      visualPadding = 10;
      windowWidth = $(window).width();
      windowHeight = $(window).height();
      scrollTop = $(window).scrollTop();
      zIndex = parseInt(this.$element.parents().first().css('z-index'), 10) + 10;
      offset = this.component ? this.omponent.parent().offset() : this.$element.offset();
      height = this.component ? this.component.outerHeight(true) : this.$element.outerHeight(false);
      width = this.component ? this.component.outerWidth(true) : this.$element.outerWidth(false);
      left = offset.left;
      top = offset.top;
      this.$widget.removeClass('textdropdown-orient-top textdropdown-orient-bottom textdropdown-orient-right textdropdown-orient-left');
      if (this.orientation.x !== 'auto') {
        this.picker.addClass('textdropdown-orient-' + this.orientation.x);
        if (this.orientation.x === 'right') {
          left -= widgetWidth - width;
        }
      } else {
        this.$widget.addClass('textdropdown-orient-left');
        if (offset.left < 0) {
          left -= offset.left - visualPadding;
        } else if (offset.left + widgetWidth > windowWidth) {
          left = windowWidth - widgetWidth - visualPadding;
        }
      }
      yorient = this.orientation.y;
      topOverflow = void 0;
      bottomOverflow = void 0;
      if (yorient === 'auto') {
        topOverflow = -scrollTop + offset.top - widgetHeight;
        bottomOverflow = scrollTop + windowHeight - (offset.top + height + widgetHeight);
        if (Math.max(topOverflow, bottomOverflow) === bottomOverflow) {
          yorient = 'top';
        } else {
          yorient = 'bottom';
        }
      }
      this.$widget.addClass('textdropdown-orient-' + yorient);
      if (yorient === 'top') {
        top += height;
      } else {
        top -= widgetHeight + parseInt(this.$widget.css('padding-top'), 10);
      }
      return this.$widget.css({
        top: top,
        left: left,
        zIndex: zIndex
      });
    },
    remove: function() {
      $('document').off('.textdropdown');
      if (this.$widget) {
        this.$widget.remove();
      }
      return delete this.$element.data().textdropdown;
    },
    setText: function(text, ignoreWidget) {
      if (!text) {
        this.clear();
        return;
      }
      this.text = text;
      return this.update(ignoreWidget);
    },
    showWidget: function(e) {
      var self;
      e.preventDefault();
      if (this.isOpen) {
        return;
      }
      if (this.$element.is(':disabled')) {
        return;
      }
      this.$widget.appendTo(this.container);
      self = this;
      $(document).on('mousedown.textdropdown, touchend.textdropdown', function(e) {
        if (!(self.$element.parent().find(e.target).length || self.$widget.is(e.target) || self.$widget.find(e.target).length)) {
          return self.hideWidget();
        }
      });
      this.$element.trigger({
        'type': 'show.textdropdown',
        'text': {
          'value': this.getText()
        }
      });
      this.place();
      this.$element.blur();
      if (this.isOpen === false) {
        this.$widget.addClass('open');
      }
      this.$widget.find("textarea").focus();
      return this.isOpen = true;
    },
    update: function(ignoreWidget) {
      this.updateElement();
      if (!ignoreWidget) {
        return this.updateWidget();
      }
    },
    updateElement: function() {
      return this.$element.val(this.getText()).change();
    },
    updateFromElementVal: function() {
      return this.setText(this.$element.val());
    },
    updateWidget: function() {
      var text;
      if (this.$widget === false) {
        return;
      }
      text = this.text;
      return this.$widget.find('.bootstrap-text-dropdown-body').val(text);
    },
    updateFromWidgetInputs: function() {
      var t;
      if (this.$widget === false) {
        return;
      }
      t = this.$widget.find('.bootstrap-text-dropdown-body').val();
      return this.setText(t, true);
    },
    widgetClick: function(e) {
      var $input, action;
      e.stopPropagation();
      e.preventDefault();
      $input = $(e.target);
      action = $input.closest('a').data('action');
      if (action) {
        this[action]();
      }
      return this.update();
    },
    widgetKeyup: function(e) {
      return this.updateFromWidgetInputs();
    }
  };
  $.fn.textdropdown = function(option) {
    var args;
    args = Array.apply(null, arguments);
    args.shift();
    return this.each(function() {
      var $this, data, options;
      $this = $(this);
      data = $this.data('textdropdown');
      options = typeof option === 'object' && option;
      if (!data) {
        $this.data('textdropdown', (data = new Textdropdown(this, $.extend({}, $.fn.textdropdown.defaults, options, $(this).data()))));
      }
      if (typeof option === 'string') {
        return data[option].apply(data, args);
      }
    });
  };
  $.fn.textdropdown.defaults = {
    isOpen: false,
    orientation: {
      x: 'auto',
      y: 'auto'
    },
    container: 'body'
  };
  return $.fn.textdropdown.Constructor = Textdropdown;
})(jQuery, window, document);
