$(document).ready(function () {
  var projectId = getProjectIdFromUrl();
  document.getElementById("project-id-field").value = projectId;
  document.getElementById("project-id").innerHTML = projectId;

  function getProjectIdFromUrl() {
    var url = window.location.href;
    var regex = /projects\/(\d+)/;
    var match = url.match(regex);
    if (match && match.length > 1) {
      // console.log(match[1], "match");
      return match[1];
    }
    return null;
  }
});
