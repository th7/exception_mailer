require 'exception_mailer/mailer'

module ExceptionMailer
  class << self
    attr_accessor :server, :port, :to, :from, :subject

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

  # defaults
  self.server  = 'localhost'
  self.port    = 25
  self.from    = 'ExceptionMailer'
  self.subject = 'Exception Occurred'

  def mail_exceptions(opts={}, &block)
    ExceptionMailer.mail_exceptions(opts, &block)
  end
end
