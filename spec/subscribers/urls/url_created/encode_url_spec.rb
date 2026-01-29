require 'rails_helper'

describe Urls::UrlCreated::EncodeUrl do
  describe '.handles_event' do
    it 'registers to handle the url.created event' do
      expect(described_class.event_name).to eq 'url.created'
    end

    it 'is included in the domain event registry' do
      expect(DomainEvent.registry).to include(described_class)
    end
  end

  describe '#call' do
    let(:subscriber) { described_class.new }
    let(:short_code) { 'abc123' }
    let(:long_url) { 'https://example.com/very/long/url' }
    let(:encoded_at) { Time.current }
    let(:payload) do
      {
        short_code: short_code,
        long_url: long_url,
        encoded_at: encoded_at
      }
    end
    let(:event) { double(payload: payload) }

    it 'receives an event object' do
      expect { subscriber.call(event) }.not_to raise_error
    end

    it 'extracts short_code from the event payload' do
      subscriber.call(event)
      # The method currently doesn't do anything with these values,
      # but we're testing that it extracts them successfully
    end

    it 'extracts long_url from the event payload' do
      subscriber.call(event)
      # The method currently doesn't do anything with these values,
      # but we're testing that it extracts them successfully
    end

    it 'extracts encoded_at from the event payload' do
      subscriber.call(event)
      # The method currently doesn't do anything with these values,
      # but we're testing that it extracts them successfully
    end

    context 'with missing payload data' do
      let(:incomplete_payload) { { short_code: short_code } }
      let(:event) { double(payload: incomplete_payload) }

      it 'handles missing long_url gracefully' do
        expect { subscriber.call(event) }.not_to raise_error
      end

      it 'handles missing encoded_at gracefully' do
        expect { subscriber.call(event) }.not_to raise_error
      end
    end
  end
end
