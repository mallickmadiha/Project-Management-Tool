import consumer from "./consumer"

document.addEventListener("DOMContentLoaded", function() {
  
  var ProjectId = window.location.pathname.split("/")[2]
  
  consumer.subscriptions.create({ channel: "ChatChannel", project_id: ProjectId }, {
    connected() {
      console.log('Connected to the chat room!')
    },
    
    received(data) {
      console.log(data)
      
      const detailsId = data.detailsId;
      console.log("Received detailsId:", detailsId);
      
      var containerId = "#chat-container" + detailsId.toString()
      console.log(data.chat.message)
      
      // To fix the issue of duplicate messages
      if (document.querySelector(containerId).innerHTML.indexOf(data.chat.message) == -1) {
        $(containerId).append("<div class='message'>" + data.chat.message + "</div>")
      }
      
      // Clear the input field after a new message is received
      var messageId = '#chat_message_' + detailsId.toString()
      document.querySelector(messageId).value = ''

      var senderId = '#chat_sender_' + detailsId.toString()
      document.querySelector(senderId).value = ''

      // Enable the submit button after clearing the message field
      var submitButtonId = '#chat_submit_' + detailsId.toString()
      document.querySelector(submitButtonId).disabled = false;
    }
  });
  })
