class DevelopmentMailInterceptor
  def self.delivering_email(message)
    message.subject = "[#{message.to}] #{message.subject}"
    message.to = ENV['DEVELOPER_EMAIL'] || "developer@example.com"
  end
end