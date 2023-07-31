$(document).ready(function () {
  var projectId = getProjectIdFromUrl();

  if (projectId === null) {
    projectId = document.getElementById("search_items_project_id").value;
  }

  function getProjectIdFromUrl() {
    var url = window.location.href;
    var regex = /projects\/(\d+)/;
    var match = url.match(regex);
    if (match && match.length > 1) {
      return match[1];
    }
    return null;
  }

  if (parseInt(document.getElementById("notificationCounter").textContent) > 0){
    var notiButton = document
    .getElementById("notificationButton")
    .querySelector("span");
    notiButton.classList.remove("displayNone");
  }

  document.getElementById("mark-close-button").addEventListener("click", function(event){
    event.preventDefault();
    document.getElementById("notificationContainer").classList.remove("show");
  })

  document
    .getElementById("mark-read-button")
    .addEventListener("click", function (event) {
      event.preventDefault();

      document.getElementById("notificationContainer").classList.remove("show");
      var notiButton = document
        .getElementById("notificationButton")
        .querySelector("span");
        
        $.ajax({
          url: "/notifications/mark_read",
          method: "POST",
          headers: {
            "X-CSRF-Token": authenticityToken,
          },
          dataType: "json",
          success: function () {
            notiButton.classList.add("displayNone");
            document.getElementById("notificationCounter").innerHTML = 0;
            var notificationListItems = document.querySelectorAll("#notificationContainer li");
            notificationListItems.forEach(function (item) {
              item.remove();
            });    
        },
      });
    });

  var authenticityToken = $('meta[name="csrf-token"]').attr("content");

  var cards = document.querySelectorAll("[data-toggle='collapse']");

  cards.forEach(function (card) {
    card.addEventListener("click", function () {
      if (this.id == "topnav"){
        return;
      }
      var detailContainer =
        this.nextElementSibling.querySelector(".detail-container");
      var itemId = detailContainer.getAttribute("data-item-id");

      var closeButton = document.getElementById("detailCloseButton" + itemId);
      closeButton.addEventListener("click", function () {
        var collapseElement = document.getElementById(
          "collapseExample" + itemId
        );
        collapseElement.classList.remove("show");
      });

      $(document).ready(function () {
        var chatInput = $("#chat_message_" + itemId);
        var searchResultsContainer = $("#search-results-chat" + itemId);
        var isTextSearchable = false;

        chatInput.on("input", function () {
          var inputValue = chatInput.val();

          var lastAtSymbolIndex = inputValue.lastIndexOf("@");
          if (lastAtSymbolIndex !== -1) {
            var searchText = inputValue.substring(lastAtSymbolIndex + 1);
            showUserDropdown(searchText);
          } else {
            searchResultsContainer.html("");
          }
        });

        searchResultsContainer.on(
          "click",
          ".search-results-chat" + itemId,
          function (event) {
            var selectedItem = $(event.target);
            var selectedValue = selectedItem.text();

            insertValueAtCursor(chatInput[0], selectedValue);

            searchResultsContainer.html("");
          }
        );

        function showUserDropdown(value) {
          searchResultsContainer.html("");

          value = value.replace("@", "");

          var authenticityToken = $('meta[name="csrf-token"]').attr("content");
          $.ajax({
            url: "/search/" + itemId,
            method: "POST",
            data: { query: value },
            headers: {
              "X-CSRF-Token": authenticityToken,
            },
            dataType: "json",
            success: function (response) {
              searchResultsContainer.html("");

              var resultItems = [];

              response.forEach(function (result) {
                var resultItem = $(
                  "<div class='search-results-chat" +
                    itemId +
                    " search-results-text'></div>"
                );
                resultItem.text(result.username);
                resultItems.push(resultItem);
              });

              searchResultsContainer.append(resultItems);

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

        searchCurrentResultsContainer.innerHTML = "";

        if (query !== "") {
          var authenticityToken = document
            .querySelector('meta[name="csrf-token"]')
            .getAttribute("content");

          $.ajax({
            url: `/search/` + itemId,
            method: "POST",
            data: { query: query },
            headers: {
              "X-CSRF-Token": authenticityToken,
            },
            dataType: "json",
            success: function (response) {
              response.forEach(function (result) {
                var resultItem = document.createElement("div");

                resultItem.classList.add("search-result-value");
                resultItem.textContent = result.username;
                searchCurrentResultsContainer.appendChild(resultItem);
              });
            },
          });
        }

        searchCurrentResultsContainer.addEventListener(
          "click",
          function (event) {
            var selectedItem = event.target;
            var selectedValue = selectedItem.textContent;

            searchCurrentInput.value = selectedValue;

            var belowDiv = document.getElementById("search-results" + itemId);
            belowDiv.innerHTML = "";
          }
        );
      });

      function createCheckboxClickListener(itemId) {
        return function (event) {
          var detailId = itemId;
          var taskId = event.target.dataset.taskId || event.target.value;

          var completed = event.target.checked ? "Done" : "Added";

          $.ajax({
            url: `/projects/${projectId}/details/${detailId}/tasks/${taskId}`,
            type: "PATCH",
            dataType: "json",
            contentType: "application/json",
            data: JSON.stringify({ task: { status: completed } }),
            headers: { "X-CSRF-Token": authenticityToken },
            success: function (response) {
              showNotification(`Task Updated Successfully`);

              var completedTasksCount = response.completedTasksCount;
              var totalTasksCount = response.totalTasksCount;

              var taskCountId = "taskCount" + detailId;
              var taskCountElement = document.getElementById(taskCountId);
              taskCountElement.innerText = `Tasks: (${completedTasksCount} / ${totalTasksCount})`;
            },
          });
        };
      }

      function addTask(itemId) {
        var taskName = document
          .getElementById("task_name" + itemId)
          .value.trim();

        if (taskName === "") {
          showNotification("Please Enter a Task");
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
            showNotification("Task Added Successfully");

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

            var checkboxId = "detail_task_ids_" + taskId;
            var checkbox = document.getElementById(checkboxId);
            checkbox.addEventListener(
              "click",
              createCheckboxClickListener(itemId)
            );
          },
        });
      }

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

      function showNotification(text) {
        if (text) {
          const notification = document.createElement("div");
          notification.classList.add("notification");
          notification.innerText = text;

          document.body.appendChild(notification);

          setTimeout(function () {
            notification.classList.add("show");
            setTimeout(function () {
              closeNotification(notification);
            }, 3000);
          }, 100);
        }
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
