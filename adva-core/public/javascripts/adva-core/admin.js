$(document).ready(function() {
  $('input.section_type[type=radio]').change(function() {
    this.form.submit();
  });
});
