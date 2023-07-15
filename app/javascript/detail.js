$(document).ready(function () {
  var projectId = getProjectIdFromUrl();

  function getProjectIdFromUrl() {
    var url = window.location.href;
    var regex = /projects\/(\d+)/;
    var match = url.match(regex);
    if (match && match.length > 1) {
      return match[1];
    }
    return null;
  }

  // Get the authenticity token from the meta tag
  var authenticityToken = $('meta[name="csrf-token"]').attr("content");

  // Get all the cards
  var cards = document.querySelectorAll("[data-toggle='collapse']");

  // Attach click event listener to each card
  cards.forEach(function (card) {
    card.addEventListener("click", function () {
      var detailContainer =
        this.nextElementSibling.querySelector(".detail-container");
      var itemId = detailContainer.getAttribute("data-item-id");
      console.log(itemId);
      // Do further processing with the itemId here

      // Add an event listener to the close button
      var closeButton = document.getElementById("detailCloseButton" + itemId);
      closeButton.addEventListener("click", function () {
        // Find the collapse element and hide it
        var collapseElement = document.getElementById(
          "collapseExample" + itemId
        );
        collapseElement.classList.remove("show");
      });

      $(document).ready(function () {
        var chatInput = $("#chat_message_" + itemId);
        var searchResultsContainer = $("#search-results-chat" + itemId);
        var isTextSearchable = false;

        // Event listener for the chat input field
        chatInput.on("input", function () {
          var inputValue = chatInput.val();
          // to get the most recent @ mention
          var lastAtSymbolIndex = inputValue.lastIndexOf("@");
          if (lastAtSymbolIndex !== -1) {
            var searchText = inputValue.substring(lastAtSymbolIndex + 1);
            showUserDropdown(searchText);
          } else {
            searchResultsContainer.html("");
          }
        });

        chatInput.on("keypress", function (event) {
          if (event.key === " ") {
            console.log("special key pressed");
          }
        });

        // Event listener for the search results container
        searchResultsContainer.on(
          "click",
          ".search-results-chat" + itemId,
          function (event) {
            var selectedItem = $(event.target);
            var selectedValue = selectedItem.text();

            // Insert the selected value at the current cursor position in the chat input
            insertValueAtCursor(chatInput[0], selectedValue);

            // Clear the search results container
            searchResultsContainer.html("");
          }
        );
        // Function to show the dropdown with all users
        function showUserDropdown(value) {
          // Clear previous search results
          searchResultsContainer.html("");

          value = value.replace("@", "");
          console.log(value);
          // Get the authenticity token from the meta tag
          var authenticityToken = $('meta[name="csrf-token"]').attr("content");
          $.ajax({
            url: "/search/" + itemId,
            method: "POST",
            data: { query: value },
            headers: {
              "X-CSRF-Token": authenticityToken, // Include the authenticity token in the request headers
            },
            dataType: "json",
            success: function (response) {
              // Clear previous search results
              searchResultsContainer.html("");

              // Create an empty array to store the search result items
              var resultItems = [];

              // Loop through the search results and create the result item elements
              response.forEach(function (result) {
                var resultItem = $("<div class='search-results-chat" + itemId + " search-results-text'></div>");
                resultItem.text(result.username); // Update with your data structure
                resultItems.push(resultItem);
              });

              // Append the result items to the search results container
              searchResultsContainer.append(resultItems);

              // Show the search results container
              searchResultsContainer.show();
            },
          });
        }

        function insertValueAtCursor(inputElement, value) {
          var inputValue = inputElement.value;
          var atIndex = inputValue.lastIndexOf("@");
          if (atIndex !== -1) {
            var prefix = inputValue.substring(0, atIndex + 1);
            inputElement.value = prefix + value;
          } else {
            inputElement.value = value;
          }
        }
      });

      var searchInput = document.getElementById("search-input" + itemId);
      var searchResultsContainer = document.getElementById(
        "search-results" + itemId
      );

      searchInput.addEventListener("input", function () {
        var searchCurrentInput = document.getElementById(
          "search-input" + itemId
        );
        var searchCurrentResultsContainer = document.getElementById(
          "search-results" + itemId
        );
        var query = searchCurrentInput.value.trim();

        // Clear previous search results
        searchCurrentResultsContainer.innerHTML = "";

        // Perform search and update results
        if (query !== "") {
          // Get the authenticity token from the meta tag
          var authenticityToken = document
            .querySelector('meta[name="csrf-token"]')
            .getAttribute("content");

          // Send an Ajax request to the search endpoint
          $.ajax({
            url: `/search/` + itemId,
            method: "POST",
            data: { query: query },
            headers: {
              "X-CSRF-Token": authenticityToken, // Include the authenticity token in the request headers
            },
            dataType: "json",
            success: function (response) {
              // Loop through the search results and add them to the container
              response.forEach(function (result) {
                var resultItem = document.createElement("div");
                // add class to the result item
                resultItem.classList.add("search-result-value");
                resultItem.textContent = result.email; // Update with your data structure
                searchCurrentResultsContainer.appendChild(resultItem);
              });
            },
          });
        }
        // Event listener for the search results container
        searchCurrentResultsContainer.addEventListener(
          "click",
          function (event) {
            var selectedItem = event.target;
            var selectedValue = selectedItem.textContent;

            // Set the selected value in the input field
            searchCurrentInput.value = selectedValue;

            // Clear the below div by setting its innerHTML to an empty string
            var belowDiv = document.getElementById("search-results" + itemId);
            belowDiv.innerHTML = "";
          }
        );
      });

      // Task related

      // Function factory to create checkbox click event listener with encapsulated item.id
      function createCheckboxClickListener(itemId) {
        return function (event) {
          var detailId = itemId;
          var taskId = event.target.dataset.taskId || event.target.value;

          // Determine if the checkbox is checked or unchecked
          var completed = event.target.checked ? "Done" : "Added";

          // Send PATCH request to update the task status
          $.ajax({
            url: `/projects/${projectId}/details/${detailId}/tasks/${taskId}`,
            type: "PATCH",
            dataType: "json",
            contentType: "application/json",
            data: JSON.stringify({ task: { status: completed } }),
            headers: { "X-CSRF-Token": authenticityToken },
            success: function (response) {
              console.log(response.message);
              showNotification(`Task ${taskId} Updated Successfully`);

              // Update the task count
              var completedTasksCount = response.completedTasksCount;
              var totalTasksCount = response.totalTasksCount;

              var taskCountId = "taskCount" + detailId;
              var taskCountElement = document.getElementById(taskCountId);
              taskCountElement.innerText = `Tasks: (${completedTasksCount} / ${totalTasksCount})`;
            },
            error: function (xhr, status, error) {
              console.error("Error: " + error);
            },
          });
        };
      }

      // Function to add a new task
      function addTask(itemId) {
        console.log(itemId);
        var taskName = document
          .getElementById("task_name" + itemId)
          .value.trim();

        if (taskName === "") {
          console.log("Task name cannot be empty.");
          return;
        }
        var detailId = itemId;

        $.ajax({
          url: `/projects/${projectId}/details/${detailId}/tasks`,
          type: "POST",
          dataType: "json",
          contentType: "application/json",
          data: JSON.stringify({ task: { name: taskName } }),
          headers: { "X-CSRF-Token": authenticityToken },
          success: function (response) {
            console.log(response.message);
            showNotification("Task Added Successfully");
            console.log("Task ID:", response.id);

            // Update the task count
            var completedTasksCount = response.completedTasksCount;
            var totalTasksCount = response.totalTasksCount + 1;

            var taskCountId = "taskCount" + detailId;
            var taskCountElement = document.getElementById(taskCountId);
            taskCountElement.innerText = `Tasks: (${completedTasksCount} / ${totalTasksCount})`;

            var taskId = response.id;

            var taskContainer = document.getElementById(
              "taskContainer" + itemId
            );
            var newTaskElement = document.createElement("div");
            newTaskElement.innerHTML = `
                <div class="field form-group text-dark my-3">
                <div class="form-check mx-4">
                    <input type="checkbox" name="detail[task_ids][]" value="${taskId}" class="form-check-input task-checkbox${taskId}" data-project_id="${projectId}" data-detail_id="${itemId}" data-task_id="${taskId}" id="detail_task_ids_${taskId}">
                    <label class="form-check-label">${taskName}</label>
                </div>
                </div>`;

            taskContainer.appendChild(newTaskElement);
            document.getElementById("task_name" + itemId).value = "";

            // Add event listener to the newly created checkbox
            var checkboxId = "detail_task_ids_" + taskId;
            var checkbox = document.getElementById(checkboxId);
            checkbox.addEventListener(
              "click",
              createCheckboxClickListener(itemId)
            );
          },
          error: function (xhr, status, error) {
            console.error("Error: " + error);
          },
        });
      }

      // Event listeners
      document
        .getElementById("addTaskButton" + itemId)
        .addEventListener("click", function () {
          addTask(itemId);
        });

      document
        .getElementById("task_name" + itemId)
        .addEventListener("keydown", function (event) {
          if (event.key === "Enter") {
            addTask(itemId);
            event.preventDefault();
          }
        });

      document.addEventListener("click", function (event) {
        if (event.target.classList.contains("task-checkbox" + itemId)) {
          createCheckboxClickListener(itemId)(event);
        }
      });

      // show notification
      function showNotification(text) {
        const notification = document.createElement("div");
        notification.classList.add("notification");
        notification.innerText = text;

        document.body.appendChild(notification);

        // Show the notification for a few seconds
        setTimeout(function () {
          notification.classList.add("show");
          setTimeout(function () {
            closeNotification(notification);
          }, 3000);
        }, 100);
      }

      function closeNotification(notification) {
        notification.classList.remove("show");
        setTimeout(function () {
          document.body.removeChild(notification);
        }, 300);
      }
    });
  });
});
