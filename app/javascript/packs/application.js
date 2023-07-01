import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
// import "../controllers/slim_controller"
// import 'slim-select/dist/slimselect.css'
import SlimSelect from 'slim-select'
// 
import "jquery"
// 

Rails.start()
Turbolinks.start()
ActiveStorage.start()


// $(document).ready(function() {
//     console.log("duwyiueywehdkjshdkjds")
//   });


$(document).on('turbolinks:load', function () {
  new SlimSelect({
    placeholder: 'Select a user',
    select: '.search-select',
    settings: {
      closeOnSelect: false,
    },
  });
  console.log('turbolinks:load')
})
