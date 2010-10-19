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
});
