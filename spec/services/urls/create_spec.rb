require 'rails_helper'

describe Urls::Create do
  let(:params) { { long_url: 'https://example.com' } }
  let(:url) { instance_double(Url) }
  let(:encode_instance) { instance_double(Encode) }
  let(:service) { described_class.new(params) }

  describe '#initialize' do
    it 'sets the params' do
      expect(service.instance_variable_get(:@params)).to eq(params)
    end
  end

  describe '#call' do
    context 'when url saves successfully' do
      let(:short_code) { 'abc123' }

      before do
        allow(Url).to receive(:new).and_return(url)
        allow(url).to receive(:save).and_return(true)
        allow(url).to receive(:id).and_return(1)
        allow(url).to receive(:short_code).and_return(short_code)
        allow(url).to receive(:long_url).and_return(params[:long_url])
        allow(url).to receive(:update_column)
        allow(Encode).to receive(:new).and_return(encode_instance)
        allow(encode_instance).to receive(:generate).and_return(short_code)
        allow(ActiveSupport::Notifications).to receive(:instrument)
      end

      it 'creates a new url' do
        service.call
        expect(Url).to have_received(:new).with(params)
      end

      it 'saves the url' do
        service.call
        expect(url).to have_received(:save)
      end

      it 'updates the short code' do
        service.call
        expect(url).to have_received(:update_column).with(:short_code, short_code)
      end

      it 'publishes the url encoded event' do
        service.call
        expect(ActiveSupport::Notifications).to have_received(:instrument).with(
          "url.created",
          short_code: short_code,
          long_url: params[:long_url],
          encoded_at: an_instance_of(ActiveSupport::TimeWithZone)
        )
      end

      it 'returns a success result' do
        result = service.call
        expect(result).to be_success
        expect(result.value).to eq(url)
      end
    end

    context 'when url fails to save' do
      let(:errors) { [ 'Long url is invalid' ] }

      before do
        allow(Url).to receive(:new).and_return(url)
        allow(url).to receive(:save).and_return(false)
        allow(url).to receive(:errors).and_return(double(full_messages: errors))
        allow(url).to receive(:update_column)
        allow(ActiveSupport::Notifications).to receive(:instrument)
      end

      it 'does not update short code or publish event' do
        service.call
        expect(url).not_to have_received(:update_column)
        expect(ActiveSupport::Notifications).not_to have_received(:instrument)
      end

      it 'returns a failure result' do
        result = service.call
        expect(result).to be_failure
        expect(result.errors).to eq(errors)
      end
    end
  end
end
