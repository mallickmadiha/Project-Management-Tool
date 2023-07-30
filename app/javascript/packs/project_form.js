$(document).ready(function () {
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

  document.getElementById("open-modal-project-create").addEventListener("click", function () {
    document.getElementById("projectForm").innerHTML = ""
    document.getElementById('project_name').value = "" 
  })

  document
    .getElementById("create-project-btn")
    .addEventListener("click", function () {
      const name = document.getElementById("project_name").value.trim();
      
      fetch("/projects", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .content,
        },
        body: JSON.stringify({
          name: name,
        }),
      })
        .then(async function (response) {
          if (response.ok) {
            document.getElementById("project_name").value = "";
            return response.json();
          } else {
            const data = await response.json();
            throw new Error(data.errors);
          }
        })
        .then(function (data) {
          showNotification("Project Created Successfully");
          let username = data.username;
          let project_id = data.project_id;

          let modalCloseBtn = document.getElementById("modal-close-btn");

          let iTag = modalCloseBtn.getElementsByTagName("i")[0];

          iTag.click();

          let projectsDisplay = document.getElementById("projects-display");

          let card = document.createElement("div");
          card.classList.add("col-md-4");
          card.innerHTML = `
             <div class="card my-3">
               <div class="card-header text-dark d-flex justify-content-end">
                <a href="projects/${project_id}/adduser" style="color:black;"
                ><i class="fa fa-solid fa-user-plus mx-2 mt-1"></i></a>
               <i class="fa fa-duotone fa-lock mx-2 mt-1"></i>
               <a href="/projects/${project_id}" target="_blank" style="color:black;">
               <i class="fa fa-solid fa-up-right-from-square mx-2"></i>
               </a>
               </div>
               <a href="/projects/${project_id}" target="_blank" style="cursor:pointer;color:black;">
                <div class="card-body">
                  <h5 class="card-title">${name}</h5>
                  <div class="d-flex justify-content-end">
                    <div class="icon-container">
                      ${username[0].toUpperCase()}
                    </div>
                </div>
               </a>
               </div>
             </div>
           `;

          projectsDisplay.prepend(card);
        })
        .catch(function (error) {
          let errorMessage = error.message;
          let errorField = document.getElementById("project_name");
          let errorParagraph = errorField.nextElementSibling;
          errorParagraph.innerHTML = errorMessage;
        });
    });
});
