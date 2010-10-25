$(document).ready(function() {
  $('input.section_type[type=radio]').change(function() {
    this.form.submit();
  });

  $('a.reorder').click(function(event) {
    $(this).parent().toggleClass('active');
    TableTree.toggle($('table.list'), $(this).attr('data-resource_type'), $(this).attr('data-sortable_type'), this.href);
    event.preventDefault();
    return false;
  })

  $('div.tabs li a').click(function() {
    tabs = $(this).closest('div');
    $('li.active, div.active', tabs).removeClass('active')
    $(this).closest('li').addClass('active');
    selected = '#tab_' + $(this).attr('href').replace('#', '');
    $(selected).addClass('active');
  });

});
