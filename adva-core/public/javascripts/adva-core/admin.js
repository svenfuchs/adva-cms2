$(document).ready(function() {
  $('input.section_type[type=radio]').change(function() {
    this.form.submit();
  });

  $('a.reorder').click(function(event) {
    $(this).parent().toggleClass('active');
    var url = this.href.split('/').slice(0, -1).join('/');
    TableTree.toggle($('table.list'), $(this).attr('data-resource_type'), $(this).attr('data-sortable_type'), url);
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

  $('table.list .toggle').click(function(event) {
    $(this).hasClass('open') ? $(this).removeClass('open').addClass('closed') : $(this).removeClass('closed').addClass('open');
    $(this).closest('tr').next().toggle();
    event.stopPropagation();
    return false;
  });
});
