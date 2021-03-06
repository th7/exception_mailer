require 'exception_mailer/mailer'

module ExceptionMailer
  class << self
    attr_accessor :host, :server, :port, :account, :password, :to, :from, :subject, :auth_method

    def configure
      yield self
    end

    def mail_exceptions(opts={})
      yield
    rescue Exception => e
      Mailer.new(opts).send_notification(e)
      raise e
    end
  end

  self.server  = 'localhost'
  self.port    = 25
  self.from    = 'ExceptionMailer'
  self.subject = 'Exception Occurred'

  def mail_exceptions(opts={}, &block)
    ExceptionMailer.mail_exceptions(opts, &block)
  end
end
