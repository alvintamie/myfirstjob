class SendJobRejectionMessageWorker
	#@queue = :send_activation_link
  include Sidekiq::Worker
  sidekiq_options :retry => false

	def perform(user_id, job_id)
		user = User.find(user_id)
		job = Job.find(job_id)
	    MailUser.send_job_rejection_message(user, job.rejected_message).deliver
	end
end