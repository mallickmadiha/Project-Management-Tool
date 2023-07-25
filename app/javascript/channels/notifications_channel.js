import consumer from "./consumer";

document.addEventListener("turbolinks:load", function () {
  consumer.subscriptions.create("NotificationsChannel", {
    connected() {},

    disconnected() {},

    received(data) {
      var notificationClass = "list-group-text" + data.id;

      const existingNotification = document.querySelector(
        `.${notificationClass}`
      );

      if (existingNotification) {
        return;
      }

      const notificationItem = document.createElement("li");
      notificationItem.classList.add("list-group-item");
      notificationItem.classList.add(notificationClass);
      notificationItem.textContent = data.message;

      var url = window.location.pathname.split("/");
    
      if ((url[1] === "projects" && url.length > 2) || url[1] === "search_items") {
        notificationContainer.prepend(notificationItem);
        var counterElement = document.getElementById("notificationCounter");
        var counter = parseInt(counterElement.textContent);
        counter += 1;
        counterElement.textContent = counter;
      }
    
    },
  });
});
