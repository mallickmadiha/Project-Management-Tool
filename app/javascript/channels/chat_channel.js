import consumer from "./consumer";

document.addEventListener("turbolinks:load", function () {
  var ProjectId = window.location.pathname.split("/")[2];

  consumer.subscriptions.create(
    { channel: "ChatChannel", project_id: ProjectId },
    {
      connected() {
        console.log("Connected to the chat room!");
      },

      received(data) {
        console.log(data);

        const detailsId = data.detailsId;
        console.log("Received detailsId:", detailsId);

        var containerId = "#chat-container" + detailsId.toString();
        var container = $(containerId);
        console.log(data.chat.message);

        container.append(
          "<div class='d-flex justify-content-start'>" +
            "<div class='icon-container mt-2 mx-2'>" +
            data.sender_username[0].toUpperCase() +
            "</div>" +
            "<div class='message py-2'>" +
            data.chat.message.replace(/@(\w+)/g, "<span class='bold-username'>@$1</span>") +
            "</div>" +
            "</div>"
        );
        
        // Clear the input field after a new message is received
        var messageId = "#chat_message_" + detailsId.toString();
        document.querySelector(messageId).value = "";
      },
    }
  );
});
