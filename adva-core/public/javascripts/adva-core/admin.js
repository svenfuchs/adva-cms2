$(document).ready(function() {
  $('input.section_type[type=radio]').change(function() {
    this.form.submit();
  });

  $('a.reorder').click(function(event) {
    $(this).parent().toggleClass('active');
    var types = this.id.split('_').slice(1, 3);
    TableTree.toggle($('table.list'), types, this.href);
    event.preventDefault();
    return false;
  })
});
