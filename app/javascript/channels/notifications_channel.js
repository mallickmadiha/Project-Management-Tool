import consumer from "./consumer";

document.addEventListener("turbolinks:load", function () {
  consumer.subscriptions.create("NotificationsChannel", {
    connected() {
      console.log("NotificationsChannel connected");
      // Called when the subscription is ready for use on the server
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received(data) {
      console.log(data);
      var notificationClass = "list-group-text" + data.id;
      
      // Check if a notification with the same ID already exists in the container
      const existingNotification = document.querySelector(`.${notificationClass}`);
      
      if (existingNotification) {
        return; // Exit if the notification with the same ID already exists
      }
      
      // Create a new notification element
      const notificationItem = document.createElement("li");
      notificationItem.classList.add("list-group-item");
      notificationItem.classList.add(notificationClass);
      notificationItem.textContent = data.message;
      
      notificationContainer.appendChild(notificationItem);

      var counterElement = document.getElementById('notificationCounter')
      var counter = parseInt(counterElement.textContent)
      counter +=1
      counterElement.textContent = counter;
      
    },
  });
});
