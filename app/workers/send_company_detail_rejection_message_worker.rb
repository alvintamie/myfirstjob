class SendCompanyDetailRejectionMessageWorker
	#@queue = :send_activation_link
  include Sidekiq::Worker
  sidekiq_options :retry => false

	def perform(user_id, company_detail_id)
		user = User.find(user_id)
		company_detail = CompanyDetail.find(company_detail_id)
	    MailUser.send_company_detail_rejection_message(user, company_detail.rejected_message).deliver
	end
end