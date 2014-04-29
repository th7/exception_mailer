require 'spec_helper'
require 'exception_mailer/mailer'
include ExceptionMailer

describe Mailer do
  let(:mailer) { Mailer.new(
    server: 'test server',
    port: 'test port',
    to: 'test to',
    from: 'test from',
    subject: 'test subject'
    )
  }

  describe '#send_notification' do
    let(:exception) { Exception.new 'a test exception' }
    let(:smtp) { double(send_message: nil) }
    let(:expected_server) { 'test server' }
    let(:expected_port) { 'test port' }
    let(:expected_message) { "From: <test from>\nTo: <test to>\nSubject: test subject\nDate: 2014-04-29 12:44:59 -0500\nMessage-Id: <1>\n\nException: a test exception\ntest\nbacktrace\n" }
    let(:expected_from) { 'test from' }
    let(:expected_to) { 'test to' }

    before do
      exception.set_backtrace([ 'test', 'backtrace' ])
      mailer.stub(:now).and_return(Time.new(2014, 4, 29, 12, 44, 59, '-05:00'))
      mailer.stub(:msg_id).and_return(1)
    end

    it 'passes server and port to Net::SMTP.start' do
      expect(Net::SMTP).to receive(:start).with(expected_server, expected_port)
      mailer.send_notification(exception)
    end

    it 'builds the expected message' do
      expect(Net::SMTP).to receive(:start).and_yield(smtp)
      expect(smtp).to receive(:send_message) do |msg, from, to|
        expect(msg).to eq expected_message
        expect(from).to eq expected_from
        expect(to).to eq expected_to
      end
      mailer.send_notification(exception)
    end
  end
end
