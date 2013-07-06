$(document).ready(function(){
  $(".upvote").on("click",function(event){
    testimonial_id = this.getAttribute("tid");
    tid = $(this).attr("tid");
    event.preventDefault();
      $.ajax({
         type: "GET",
         url: location.protocol + "//" + location.host + "/student/testimonials/" + testimonial_id + "/upvote",
         success: function(msg){
           if(msg.status == "success"){
              n = parseInt($("#votes-"+tid).text());
              $("#votes-"+tid).text(n+1);
           }
         }
       });
  });
  
  $(".downvote").on("click",function(event){
    testimonial_id = this.getAttribute("tid");
    tid = $(this).attr("tid");
    event.preventDefault();
      $.ajax({
         type: "GET",
         url: location.protocol + "//" + location.host + "/student/testimonials/" + testimonial_id +"/downvote",
         success: function(msg){
           if(msg.status == "success"){
              n = parseInt($("#votes-"+tid).text());
              $("#votes-"+tid).text(n-1);
           }
         }
       });
  });
})