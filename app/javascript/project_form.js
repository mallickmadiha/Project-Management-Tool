$(document).ready(function() {

document.getElementById('create-project-btn').addEventListener('click', function(){
    const name = document.getElementById('project_name').value;
 
       console.log(name);
 
       fetch('/projects', {
         method: 'POST',
         headers: {
           'Content-Type': 'application/json',
           'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
         },
         body: JSON.stringify({
             name: name
         })
       })
       .then(function(response) {
         if (response.ok) {
           // Handle the success response
          //  console.log('Project created successfully');
           // clear the input field
           document.getElementById('project_name').value = '';
           return response.json();
         } else {
           // Handle the error response
          //  console.log('Project creation failed');
         }
       })
       .then(function(data) {
        //  console.log('Response data:', data.username, data.project_id);
         let username = data.username;
         let project_id = data.project_id;
           // get button of id modal-close-btn
           let modalCloseBtn = document.getElementById('modal-close-btn');
           // now get i tag of modal-close-btn
           let iTag = modalCloseBtn.getElementsByTagName('i')[0];
           // now click on i tag
           iTag.click();
 
           // get element of id projects-display
           let projectsDisplay = document.getElementById('projects-display');
           // create the card element
           let card = document.createElement('div');
           card.classList.add('col-md-4');
           card.innerHTML = `
             <div class="card my-3">
               <div class="card-header text-dark d-flex justify-content-end">
                <a href="projects/${project_id}/adduser" style="color:black;"
                ><i class="fa fa-solid fa-user-plus mx-2 mt-1"></i></a>
               <i class="fa fa-duotone fa-lock mx-2 mt-1"></i>
               <a href="/projects/${project_id}" style="color:black;">
               <i class="fa fa-solid fa-up-right-from-square mx-2"></i>
               </a>
               </div>
               <div class="card-body">
                 <h5 class="card-title">${name}</h5>
                 <div class="d-flex justify-content-end">
                   <div class="icon-container">
                     ${username[0].toUpperCase()}
                   </div>
               </div>
               </div>
             </div>
           `;
         // append the card to the projects-display element
         projectsDisplay.prepend(card);
       })
       .catch(function(error) {
        //  console.log(error);
       });
   });

});