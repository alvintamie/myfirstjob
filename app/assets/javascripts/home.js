console.log("gila");

$(document).ready(function() {
 	$("#search_company_hub").on("click",function(event){
    	event.preventDefault();
		var value = $("#company_industry").val();
		if(value == "all"){
			window.location = "/company_hub";
		}
		else
		{
			window.location = "/company_details/industry?category="+escape(value);
		}
	});
})