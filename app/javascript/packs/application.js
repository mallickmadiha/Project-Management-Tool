import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
// import "../controllers/slim_controller"
// import 'slim-select/dist/slimselect.css'
// import SlimSelect from 'slim-select'
// 
import "jquery"
// 

Rails.start()
Turbolinks.start()
ActiveStorage.start()


$(document).ready(function() {
    console.log("duwyiueywehdkjshdkjds")
  });


// $(document).on('turbolinks:load', function() {

    // console.log(SlimSelect)
    // new SlimSelect({
    //     select: '.form-control',
    //     closeOnSelect: false,
    //     placeholder: 'Select a user',
    //     multiSelect: true
    // });
//     console.log('turbolinks:load')

// })
