def assert_sent_email(attributes)
  emails = ::ActionMailer::Base.deliveries
  assert !emails.empty?, "No emails were sent"
  matching_emails = emails.select do |email|
    attributes.all? { |name, value| email.send(name).to_s == value }
  end
  assert !matching_emails.empty?, "None of the #{emails.size} emails matched #{attributes.inspect}."
end