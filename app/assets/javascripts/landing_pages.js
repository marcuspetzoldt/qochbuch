$(document).on('click', 'span.search_usable_tag_cloud', function() {
    var $search_field = $('input#search_text')
    if ($search_field.val()) {
        flash_input($search_field);
    }
    move_tag(this, 'search_usable', 'search_used');
    refresh_tag_list('search_used');
    $('input#isearch_used').closest('form').submit();
})

$(document).on('click', 'span.search_used_tag_cloud', function() {
    var $search_field = $('input#search_text')
    if ($search_field.val()) {
        flash_input($search_field);
    }
    move_tag(this, 'search_used', 'search_usable');
    refresh_tag_list('search_used')
    $('input#isearch_used').closest('form').submit();
})

function flash_input(f) {
    $(f).css('background-color', '#ffff00')
    $(f).animate({
      backgroundColor: "#ffffff"
    }, 150);
}
