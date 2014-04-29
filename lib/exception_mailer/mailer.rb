require 'net/smtp'

module ExceptionMailer
  class Mailer
    attr_reader :host, :server, :port, :account, :password, :to, :from, :subject

    def initialize(opts)
      @host        = opts[:host]        || ExceptionMailer.host
      @server      = opts[:server]      || ExceptionMailer.server
      @port        = opts[:port]        || ExceptionMailer.port
      @account     = opts[:account]     || ExceptionMailer.account
      @password    = opts[:password]    || ExceptionMailer.password
      @auth_method = opts[:auth_method] || ExceptionMailer.auth_method
      @to          = opts[:to]          || ExceptionMailer.to
      @from        = opts[:from]        || ExceptionMailer.from
      @subject     = opts[:subject]     || ExceptionMailer.subject

      @to = [ @to ] unless @to.kind_of? Array
    end

    def send_notification(exception)
      Net::SMTP.start(*start_args) do |smtp|
        smtp.send_message(build_msg(exception), from, *to)
      end
    end

    private

    def start_args
      [ :server, :port, :host, :account, :password, :auth_method ].inject([]) do |args, arg|
        return args if send(arg).nil?
        args << send(arg)
      end
    end

    def build_msg(exception)
      <<-END_OF_MESSAGE
From: <#{from}>
#{to.map { |t| "To: <#{t}>" }.join("\n") }
Subject: #{subject}
Date: #{now}
Message-Id: <#{msg_id}>

#{body(exception)}
      END_OF_MESSAGE
    end

    def body(exception)
      [
        "#{exception.class}: #{exception.message}",
        "#{exception.backtrace.join("\n")}"
      ].join("\n")
    end

    def msg_id
      rand(1_000_000_000)
    end

    def now
      Time.now
    end
  end
end
