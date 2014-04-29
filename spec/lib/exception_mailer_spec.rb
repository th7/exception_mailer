require 'spec_helper'
require 'exception_mailer'

describe ExceptionMailer do
  describe '.mail_exceptions' do
    let(:exception) { Exception.new 'a test exception' }
    let(:mailer) { double(send_notification: nil) }
    it 'rescues exceptions and passes them to ExceptionMailer::Mailer' do
      expect(ExceptionMailer::Mailer).to receive(:new).and_return(mailer)
      expect(mailer).to receive(:send_notification).with(exception)
      expect {
        ExceptionMailer.mail_exceptions { raise exception }
      }.to raise_error exception
    end
  end

  describe '#mail_exceptions' do
    before do
      class ExceptionMailerIncluder
        include ExceptionMailer
      end
    end

    let(:opts) { double }
    let(:block) { Proc.new {} }

    it 'passes opts and block to ExceptionMailer.mail_exceptions' do
      expect(ExceptionMailer).to receive(:mail_exceptions).with(opts, &block)
      ExceptionMailerIncluder.new.mail_exceptions(opts, &block)
    end
  end
end
