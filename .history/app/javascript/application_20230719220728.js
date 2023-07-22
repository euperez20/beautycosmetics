// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

//= require jquery3
//= require popper
//= require bootstrap

// import 'bootstrap/dist/js/bootstrap';
// import 'bootstrap/dist/css/bootstrap';

document.addEventListener("turbolinks:load", function() {
    const dropdownButton = document.getElementById("categoryDropdown");
    dropdownButton.addEventListener("click", function() {
      this.classList.toggle("show");
    });
  
    document.addEventListener("click", function(event) {
      if (!dropdownButton.contains(event.target)) {
        dropdownButton.classList.remove("show");
      }
    });
  });