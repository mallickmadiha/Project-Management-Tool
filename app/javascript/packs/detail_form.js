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

  $(".submit-button").on("click", function (event) {
    event.preventDefault();
    var submitId = $(this).data("submit-id");

    document.getElementById("detail_title" + submitId).value = "";
    document.getElementById("detail_description" + submitId).value = "";
    document.getElementById("detail_file" + submitId).value = "";

    var closeButton = document.getElementById("modalCloseButton" + submitId);
    closeButton.addEventListener("click", function () {
      var collapseElement = document.getElementById("collapseOne" + submitId);
      collapseElement.classList.remove("show");
    });
  });

  $(".submit-feature").on("click", function (event) {
    event.preventDefault();
    var submitId = $(this).data("submit-id");
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
    var title = document.getElementById("detail_title" + submitId).value;
    var description = document.getElementById(
      "detail_description" + submitId
    ).value;
    var flagType = document.getElementById("detail_flagType" + submitId).value;
    var fileInput = document.getElementById("detail_file" + submitId);
    var project_id = document.getElementById(
      "detail_project_id" + submitId
    ).value;

    var formData = new FormData();
    formData.append("detail[title]", title);
    formData.append("detail[description]", description);
    formData.append("detail[flagType]", flagType);
    formData.append("detail[project_id]", project_id);

    for (var i = 0; i < fileInput.files.length; i++) {
      formData.append("detail[file][]", fileInput.files[i]);
    }

    if (title && description && project_id) {
      $.ajax({
        url: `/projects/${projectId}/details/`,
        method: "POST",
        accept: "application/json",
        data: formData,
        processData: false,
        contentType: false,
        beforeSend: function (xhr) {
          xhr.setRequestHeader(
            "X-CSRF-Token",
            $('meta[name="csrf-token"]').attr("content")
          );
        },
        success: function (response) {
          document.getElementById("detail_title" + submitId).value = "";
          document.getElementById("detail_description" + submitId).value = "";
          document.getElementById("detail_flagType" + submitId).value =
            "backFlag";
          document.getElementById("detail_file" + submitId).value = "";

          var collapseElement = document.getElementById(
            "collapseOne" + submitId
          );
          collapseElement.classList.remove("show");

          let uuid = response.detail;
          let id = response.id;
          let project_id = response.project_id;
          let tasks = response.tasks;
          let users = response.users;
          let current_user = response.current_user;

          showNotification(`Feature is Successfully Added`);

          let files = formData.getAll("detail[file][]");
          var container = document.getElementById(submitId + "-details-list");
          var newDetail = document.createElement("div");
          newDetail.innerHTML = `
        <div type="button" class="mt-2" data-toggle="collapse" data-target="#collapseExample${id}" aria-expanded="false" aria-controls="collapseExample${id}">
          <div class="card">
            <div class="card-body">
              <h4 class="card-title">${title}</h4>
              <p class="card-text">${description}</p>
            </div>
          </div>
        </div>
        <div class="collapse mb-3" id="collapseExample${id}">
          <div class="card card-body">
            <div class="text-dark text-upper my-3">
              Feature Id : ${uuid}
            </div>
            <div class="text-dark text-upper my-3">
              Title : ${title}</div>
            <div class="text-dark text-upper my-3">
              Description : ${description}</div>
              <form action="/change_status/${id}" method="post" data-remote="true" id="change-status-form">
              <div class="flash-container${id}"></div>
              <div class="my-3">
                <input type="hidden" name="project_id" value="${projectId}">
                <label for="status" class="text-dark text-upper">Status:</label>
                <select name="status" class="form-select">
                  <option value="Started">Started</option>
                  <option value="Finished">Finished</option>
                  <option value="Delivered">Delivered</option>
                </select>
              </div>
              <input type="submit" value="Save" class="message-btn">
            </form>
          <div class="text-dark text-upper mt-5" id="taskCount${id}">
          Tasks: (${0}/ ${0})
        </div>
        <div id="taskContainer${id}">
          ${tasks
            .map(
              (task) => `
              <div class="field form-group text-dark my-3">
                <div class="form-check mx-4">
                  <input type="checkbox" name="detail[task_ids][]" value="${
                    task.id
                  }" ${
                task.status != "Added" ? "checked" : ""
              } class="form-check-input task-checkbox${id}" data-project_id="${projectId}" data-detail_id="${id}" data-task_id="${
                task.id
              }" id="detail_task_ids_${task.id}">
                  <label class="form-check-label">${task.name}</label>
                </div>
              </div>
            `
            )
            .join("")}
        </div>
            <div class="field form-group d-flex flex-column  flex-wrap text-dark my-3">
            <div class="flash-task-container${id}"></div>
              <div>
                <label for="task_name">Task Name</label>
                <input type="text" name="task_name" class="form-control pointer" id="task_name${id}">
                <button type="button" class="message-btn mx-0 my-3" id="addTaskButton${id}">Add Task</button>
              </div>
            </div>
            <div class="d-flex flex-column flex-wrap">
            <div class="text-dark text-upper mt-5 mb-3">
              Users Assigned to this:
            </div>
            <div class="d-flex flex-column flex-wrap">
                <div id="user-container${id}">
                  ${users.map((user) => `<p>${user.username}</p>`).join("")}
                </div>
                <form action="/projects/${project_id}/details/${id}/update_user_ids" method="post" data-remote="true">
                  <input type="text" name="username[]" id="search-input${id}" class="form-control" placeholder="Type username to search..." />
                  <input type="hidden" name="authenticity_token" value="{{form_authenticity_token}}">
                  <div id="search-results${id}"></div>
                  <button type="submit" class="message-btn mt-3">Add User</button>
                  </form>
              </div>
            </div>
            <div class="d-flex flex-column flex-wrap">
                <div class="text-dark text-upper my-3">
                  Files :
                </div>
                <div class="d-flex flex-wrap flex-column">
                  ${files
                    .map(
                      (
                        file
                      ) => `<div class="text-dark text-uppercase mx-3 fw-bold my-3">
                  ${
                    file.type.includes("image")
                      ? `<img src="${URL.createObjectURL(
                          file
                        )}" width=100 height=100 alt="${file.name}" />`
                      : ""
                  }
                  ${
                    file.type.includes("application/pdf")
                      ? `<a href="${URL.createObjectURL(
                          file
                        )}" target="_blank">View PDF</a>`
                      : ""
                  }
                  ${
                    file.type.includes("application/vnd.ms-excel") ||
                    file.type.includes(
                      "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
                    ) ||
                    file.type.includes("text/plain") ||
                    file.type.includes("text/markdown")
                      ? `<a href="${URL.createObjectURL(file)}" download="${
                          file.name
                        }">Download</a>`
                      : ""
                  }
                  ${
                    file.type.includes("application/zip") ||
                    file.type.includes("application/x-rar-compressed")
                      ? `<a href="${URL.createObjectURL(file)}" download="${
                          file.name
                        }">Download</a>`
                      : ""
                  }
                  </div>`
                    )
                    .join("")}
              </div>
            </div>
            <div class="d-flex flex-column flex-wrap">
              <div class="text-dark text-upper my-3">
                Comment Box :
              </div>
              <div class="d-flex flex-column  flex-wrap">
                <div id="chat-container${id}">
                </div>
                <form id="chat-form-${id}" data-backlog-id="${id}" method="POST" action="/chats" data-remote="true" class="bootstrap-class">
                  <input type="hidden" name="authenticity_token" value=csrfToken>
                  <div class="form-group d-flex flex-row">
                    <label for="chat_message_${id}" class="mt-3 mx-2 d-none">Message</label>
                    <div class="position-relative">
                      <textarea class="form-control my-2" name="chat[message]" id="chat_message_${id}"></textarea>
                      <div id="search-results-chat${id}" class="search-results"
                      >
                  </div>
                  <input type="hidden" name="chat[sender_id]" id="chat_sender_${id}" value="${current_user}">
                  <input type="hidden" name="chat[detail_id]" value="${id}" id="chat_details_${id}">
                  <button type="submit" class="message-btn my-3">Post Comment</button>
                </form>
              </div>
            </div>
        </div>
      <div class="d-flex justify-content-center py-3">
        <button class="btn btn-secondary mt-3 mx-3" id="detailCloseButton${id}" type="button">Close</button>
      </div>
      </div>`;

          var csrfToken = document.querySelector(
            'meta[name="csrf-token"]'
          ).content;

          var $newDetail = $(newDetail);

          $(container).prepend($newDetail);

          var chatInputId = "#chat_message_" + id;
          var chatInput = document.querySelector(chatInputId);

          var searchResultsContainerIdchat = "search-results-chat" + id;
          var searchResultsContainerchat = document.getElementById(
            searchResultsContainerIdchat
          );

          var isTextSearchable = false;
          chatInput.addEventListener("input", function () {
            var inputValue = chatInput.value;

            var lastAtSymbolIndex = inputValue.lastIndexOf("@");
            if (lastAtSymbolIndex !== -1) {
              var searchText = inputValue.substring(lastAtSymbolIndex + 1);
              showUserDropdown(searchText);
            } else {
              searchResultsContainerchat.innerHTML = "";
            }
          });

          chatInput.addEventListener("keypress", function (event) {
            if (event.key === " ") {
            }
          });

          var searchResultsContainerClass = ".search-results-chat" + id;
          searchResultsContainerchat.addEventListener(
            "click",
            function (event) {
              var selectedItem = event.target;
              var selectedValue = selectedItem.textContent;
              insertValueAtCursor(chatInput, selectedValue);
              searchResultsContainerchat.innerHTML = "";
            }
          );

          function showUserDropdown(value) {
            value = value.replace("@", "");
            var authenticityToken = $('meta[name="csrf-token"]').attr(
              "content"
            );
            $.ajax({
              url: `/search/${id}`,
              method: "POST",
              data: { query: value },
              headers: {
                "X-CSRF-Token": authenticityToken,
              },
              dataType: "json",
              success: function (response) {
                searchResultsContainerchat.innerHTML = "";
                var resultItems = [];

                response.forEach(function (result) {
                  var resultItem = document.createElement("div");
                  resultItem.className = "search-results-chat" + id;
                  resultItem.className = "search-results-text";
                  resultItem.textContent = result.username;
                  searchResultsContainerchat.appendChild(resultItem);
                });
                searchResultsContainerchat.style.display = "block";
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

          let searchInputId = "search-input" + id;

          var searchInput = document.getElementById(searchInputId);

          let searchResultsContainerId = "search-results" + id;
          var searchResultsContainer = document.getElementById(
            searchResultsContainerId
          );

          searchInput.addEventListener("input", function () {
            var searchCurrentInput = document.getElementById(searchInputId);
            var searchCurrentResultsContainer = document.getElementById(
              searchResultsContainerId
            );
            var query = searchCurrentInput.value.trim();

            searchCurrentResultsContainer.innerHTML = "";

            if (query !== "") {
              var authenticityToken = document
                .querySelector('meta[name="csrf-token"]')
                .getAttribute("content");

              $.ajax({
                url: `/search/${id}`,
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

                var belowDiv = document.getElementById(
                  searchResultsContainerId
                );
                belowDiv.innerHTML = "";
              }
            );
          });

          function createCheckboxClickListener(itemId) {
            return function (event) {
              var detailId = id;
              var taskId = event.target.dataset.taskId || event.target.value;

              var completed = event.target.checked ? "Done" : "Added";

              $.ajax({
                url: `/projects/${projectId}/details/${detailId}/tasks/${taskId}`,
                type: "PATCH",
                dataType: "json",
                contentType: "application/json",
                data: JSON.stringify({ task: { status: completed } }),
                headers: {
                  "X-CSRF-Token": csrfToken,
                },
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

            var detailId = itemId;

            $.ajax({
              url: `/projects/${projectId}/details/${detailId}/tasks`,
              type: "POST",
              dataType: "json",
              contentType: "application/json",
              data: JSON.stringify({ task: { name: taskName } }),
              headers: { "X-CSRF-Token": csrfToken },
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
              error: function (response) {
                showNotification(response.responseJSON.errors);
              },
            });
          }

          var addTaskButtonId = "addTaskButton" + id;
          document
            .getElementById(addTaskButtonId)
            .addEventListener("click", function () {
              addTask(id);
            });

          var taskNameId = "task_name" + id;
          document
            .getElementById(taskNameId)
            .addEventListener("keydown", function (event) {
              if (event.key === "Enter") {
                addTask(id);
                event.preventDefault();
              }
            });

          document.addEventListener("click", function (event) {
            var taskCheckBoxId = "task_checkbox" + id;
            if (event.target.classList.contains(taskCheckBoxId)) {
              createCheckboxClickListener(id)(event);
            }
          });

          var closeButtonDetailid = "detailCloseButton" + id;
          var closeButton = document.getElementById(closeButtonDetailid);
          closeButton.addEventListener("click", function () {
            var collapseElementid = "collapseExample" + id;
            var collapseElement = document.getElementById(collapseElementid);
            collapseElement.classList.remove("show");
          });

          function showNotification(text) {
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

          function closeNotification(notification) {
            notification.classList.remove("show");
            setTimeout(function () {
              document.body.removeChild(notification);
            }, 300);
          }
        },
        error: function (response) {
          showNotification(response.responseJSON.errors);
        },
      });
    } else {
      showNotification(`Please Fill in the required fields`);
    }
  });
});
