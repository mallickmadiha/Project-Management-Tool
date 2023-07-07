import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import SlimSelect from 'slim-select'
import "jquery"

Rails.start()
Turbolinks.start()
ActiveStorage.start()


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

