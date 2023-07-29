import Rails from "@rails/ujs";
import Turbolinks from "turbolinks";
import * as ActiveStorage from "@rails/activestorage";
import "channels";
import SlimSelect from "slim-select";
import "jquery";

Rails.start();
Turbolinks.start();
ActiveStorage.start();

$(document).on("turbolinks:load", function () {
  new SlimSelect({
    placeholder: "Select a user",
    select: ".search-select",
    settings: {
      closeOnSelect: false,
    },
  });

  const notificationContainer = document.getElementById(
    "notificationContainer"
  );
  const notificationButton = document.getElementById("notificationButton");
  let isOpen = false;

  if (notificationButton) {
    notificationButton.addEventListener("click", () => {
      isOpen = !isOpen;
      toggleNotificationContainer();
    });

    function toggleNotificationContainer() {
      if (parseInt(document.getElementById("notificationCounter").textContent) > 0) {
        notificationContainer.classList.toggle("show");
      }
    }
  }

  $("#mark-read-button").click(function () {
    $(".notification-item").remove();
    $("#notificationCounter").html("0");
  });

  if (localStorage.getItem("backlog") == "false") {
    $("#backlog").hide();
    $("#backlog-show").removeClass("active-navitem");
  }

  if (localStorage.getItem("currentIteration") == "false") {
    $("#currentIteration").hide();
    $("#currentIteration-show").removeClass("active-navitem");
  }

  if (localStorage.getItem("icebox") == "false") {
    $("#icebox").hide();
    $("#icebox-show").removeClass("active-navitem");
  }

  function toggleSidebar() {
    $("#sidebar-container").toggleClass("sidebar-expanded sidebar-collapsed");
  }

  $("#sidebar-toggle").click(function () {
    toggleSidebar();
  });

  $("#backlog-close").click(function () {
    $("#backlog").hide();
    $("#backlog-show").removeClass("active-navitem");
    localStorage.setItem("backlog", false);
  });

  $("#currentIteration-close").click(function () {
    $("#currentIteration").hide();
    $("#currentIteration-show").removeClass("active-navitem");
    localStorage.setItem("currentIteration", false);
  });

  $("#icebox-close").click(function () {
    $("#icebox").hide();
    $("#icebox-show").removeClass("active-navitem");
    localStorage.setItem("icebox", false);
  });

  $("#backlog-show").click(function () {
    $("#backlog").show();
    $("#currentIteration-show").addClass("active-navitem");
    $("#backlog-show").addClass("active-navitem");
    localStorage.setItem("backlog", true);
  });

  $("#currentIteration-show").click(function () {
    $("#currentIteration").show();
    $("#currentIteration-show").addClass("active-navitem");
    localStorage.setItem("currentIteration", true);
  });

  $("#icebox-show").click(function () {
    $("#icebox").show();
    $("#icebox-show").addClass("active-navitem");
    localStorage.setItem("icebox", true);
  });

  $("#mark-read-button").click(function () {
    $(".list-group-item").remove();
    $("#notificationCounter").html("0");
  });
});
