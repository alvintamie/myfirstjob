$ ->
	op = { dateFormat: 'dd/mm/yy', showOn: 'button', buttonImage: '/assets/button_calendar.png', buttonImageOnly: true}
	$("#job_date_posted").datepicker(op)
	$("#job_start_date").datepicker(op)
	$("#job_end_date").datepicker(op)
	$("#job_deadline").datepicker(op)

