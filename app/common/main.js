'use strict';

$(document).ready(function() {
   $("form").on("submit",function(event) {
      var url = $("#userInput").val();
      event.preventDefault();
      if (url.length>0) {
      window.location.href = window.location + "?url=" + url;
      }
   }) ;
});
