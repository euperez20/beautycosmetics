//= require rails-ujs
//= require jquery
//= require jquery_ujs
//= require_tree .

$(document).on('turbolinks:load', function () {
    
    $('form#edit_order').on('ajax:success', function (event) {
      
      const response = event.detail[0];
  
      
      $('div#order_details').html(response);
  
      // Opcional: Mostrar un mensaje de éxito
      alert('Order successfully updated.');
    }).on('ajax:error', function (event) {
      // Opcional: Mostrar un mensaje de error en caso de falla
      alert('Error updating order. Please try again.');
    });
  });