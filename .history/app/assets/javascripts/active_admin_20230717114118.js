//= require active_admin/base
$(document).on('turbolinks:load', function() {
    const imageField = $('#product_image');
    const imagePreview = $('#image-preview');
  
    imageField.on('input', function() {
      const imageUrl = $(this).val();
      imagePreview.attr('src', imageUrl);
    });
  });
  