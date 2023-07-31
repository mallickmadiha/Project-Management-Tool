import consumer from "./consumer";

document.addEventListener("turbolinks:load", function () {
  var ProjectId = window.location.pathname.split("/")[2];
  var url = window.location.pathname.split("/");

  if (
    !ProjectId && url[1] !== "projects" && url[1] !== "" && url[1] !== "signup"
  ) {
    ProjectId = document.getElementById("search_items_project_id").value;
  }
  
  consumer.subscriptions.create(
    { channel: "ChatChannel", project_id: ProjectId },
    {
      received(data) {
        const detailsId = data.detailsId;

        const messageId = data.chat.id;

        const existingMessage = $(`[data-message-id="${messageId}"]`);

        if (!existingMessage.length) {

          var containerId = "#chat-container" + detailsId.toString();
          var container = $(containerId);

          container.append(
            "<div class='d-flex justify-content-start' data-message-id='" + messageId + "'>" +
              "<div class='icon-container mt-2 mx-2'>" +
              data.sender_username[0].toUpperCase() +
              "</div>" +
              "<div class='message py-2'>" +
              data.chat.message.replace(
                /@(\w+)/g,
                "<span class='fw-bold'>@$1</span>"
              ) +
              "</div>" +
              "</div>"
          );

          var messageIdText = "#chat_message_" + detailsId.toString();
          document.querySelector(messageIdText).value = "";
        }
      },
    }
  );
});
