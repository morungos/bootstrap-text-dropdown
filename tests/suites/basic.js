module('Basic tests', {
    setup: function(){
        this.input = $('<input type="text">')
                        .appendTo('#qunit-fixture')
                        .textdropdown()
                        .focus();
        this.dropdown = this.input.data('textdropdown')
        this.widget = this.dropdown.$widget;
    },
    teardown: function(){
        this.widget.remove();
    }
});

test('Clicking the input shows the dropdown', function() {
    ok(! this.widget.is(':visible'), 'Dropdown is not visible');
    this.dropdown.$element.trigger('click');
    ok(this.widget.is(':visible'), 'Dropdown is now visible');
});

test('Clicking the dropdown does not hide dropdown', function() {
    this.dropdown.$element.trigger('click');
    this.widget.trigger('click');
    ok(this.widget.is(':visible'), 'Dropdown is still visible');
});

test('Clicking outside the dropdown does hide dropdown', function() {
    var $otherelement = $('<div />');
    $('body').append($otherelement);

    this.dropdown.$element.trigger('click');
    this.widget.trigger('click');
    ok(this.widget.is(':visible'), 'Dropdown is still visible');

    $otherelement.trigger('mousedown');
    ok(this.widget.is(':not(:visible)'), 'Dropdown is hidden');

    $otherelement.remove();
});
