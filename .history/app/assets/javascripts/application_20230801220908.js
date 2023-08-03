//= require rails-ujs
//= require jquery
//= require jquery_ujs
//= require_tree .

$(document).on('turbolinks:load', function () {
    // Escuchar el envío del formulario de edición
    $('form#edit_order').on('ajax:success', function (event) {
      // Obtener la respuesta JSON del servidor
      const response = event.detail[0];
  
      // Actualizar la vista parcial con los nuevos datos
      $('div#order_details').html(response);
  
      // Opcional: Mostrar un mensaje de éxito
      alert('Order successfully updated.');
    }).on('ajax:error', function (event) {
      // Opcional: Mostrar un mensaje de error en caso de falla
      alert('Error updating order. Please try again.');
    });
  });