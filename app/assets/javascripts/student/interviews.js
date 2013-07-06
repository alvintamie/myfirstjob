$(document).ready(function(){
	op = { dateFormat: 'dd/mm/yy', showOn: 'button', buttonImage: '/assets/button_calendar.png', buttonImageOnly: true}
	$("#interview_interview_date").datepicker(op);

  $(".upvote").on("click",function(event){
    interview_id = this.getAttribute("iid");
    console.log(interview_id);
    iid = $(this).attr("iid");
    event.preventDefault();
      $.ajax({
         type: "GET",
         url: location.protocol + "//" + location.host + "/student/interviews/" + interview_id + "/upvote",
         success: function(msg){
           if(msg.status == "success"){
              n = parseInt($("#votes-"+iid).text());
              $("#votes-"+iid).text(n+1);
           }
         }
       });
  });
  
  $(".downvote").on("click",function(event){
    interview_id = this.getAttribute("iid");
    iid = $(this).attr("iid");
    console.log(location.protocol + "//" + location.host + "/student/interviews/" + interview_id +"/downvote");
    event.preventDefault();
      $.ajax({
         type: "GET",
         url: location.protocol + "//" + location.host + "/student/interviews/" + iid +"/downvote",
         success: function(msg){
           if(msg.status == "success"){
              n = parseInt($("#votes-"+iid).text());
              $("#votes-"+iid).text(n-1);
           }
         }
       });
  });
})