def emails_for_assertion(attributes)
  ::ActionMailer::Base.deliveries.select do |email|
    attributes.all? do |name, value|
      case name
      when 'body'
        value.split(',').map(&:strip).all? { |value| email.body.include?(value) }
      else
        email.send(name).to_s == value
      end
    end
  end
end

def assert_email_sent(attributes)
  emails = ::ActionMailer::Base.deliveries
  assert !emails.empty?, "No emails were sent"
  assert !emails_for_assertion(attributes).empty?, begin
    msg = ["None of the #{emails.size} emails matched #{attributes.inspect}.\nInstead, there are the following emails:"]
    msg += emails.map { |email| attributes.keys.map { |key| [key, email.send(key)] }.map { |key, value| "#{key}: #{value}" }.join(',') }
    msg.join("\n")
  end
end

def assert_no_email_sent(attributes = {})
  if attributes.empty?
    assert ::ActionMailer::Base.deliveries.empty?
  else
    assert emails_for_assertion(attributes).empty?, "Expected none of the emails to match #{attributes.inspect}, but one did."
  end
end

