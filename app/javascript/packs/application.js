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

  // console.log("turbolinks:load");

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
      notificationContainer.classList.toggle("show");
    }
  }

  $("#mark-read-button").click(function () {
    $(".notification-item").remove();
    $("#notificationCounter").html("0");
  });

  // $("#flashModal").modal("show");
  // setTimeout(function () {
  //   $("#flashModal").modal("hide");
  // }, 2000);

  // if backlog is false in localStorage then close it
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

  // Function to toggle sidebar collapse
  function toggleSidebar() {
    $("#sidebar-container").toggleClass("sidebar-expanded sidebar-collapsed");
  }

  // Event listener for the sidebar toggle button
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
