require 'rails_helper'

describe Urls::FindShortCode do
  let(:service) { described_class.new(short_code) }
  let(:short_code) { 'abc123' }

  describe '#initialize' do
    it 'sets the short_code' do
      expect(service.instance_variable_get(:@short_code)).to eq(short_code)
    end
  end

  describe '#call' do
    context 'when URL exists with the given short code' do
      let(:url) { instance_double(Url, id: 1, short_code: short_code, long_url: 'https://example.com') }

      before do
        allow(Url).to receive(:find_by).with(short_code: short_code).and_return(url)
        allow(ActiveSupport::Notifications).to receive(:instrument)
      end

      it 'returns a success result' do
        result = service.call
        expect(result).to be_a(Result)
        expect(result.success?).to be true
      end

      it 'returns the found URL' do
        result = service.call
        expect(result.value).to eq(url)
      end

      it 'includes the correct short code in the result' do
        result = service.call
        expect(result.value.short_code).to eq(short_code)
      end

      it 'publishes the url.finded_enconded_url event' do
        service.call
        expect(ActiveSupport::Notifications).to have_received(:instrument).with(
          "url.finded_enconded_url",
          id: 1,
          short_code: short_code,
          long_url: 'https://example.com'
        )
      end

      it 'publishes event with correct URL data' do
        service.call
        expect(ActiveSupport::Notifications).to have_received(:instrument).with(
          "url.finded_enconded_url",
          hash_including(
            id: url.id,
            short_code: url.short_code,
            long_url: url.long_url
          )
        )
      end
    end

    context 'when URL does not exist with the given short code' do
      before do
        allow(Url).to receive(:find_by).with(short_code: short_code).and_return(nil)
        allow(ActiveSupport::Notifications).to receive(:instrument)
      end

      it 'returns a failure result' do
        result = service.call
        expect(result).to be_a(Result)
        expect(result.failure?).to be true
      end

      it 'returns an error message array' do
        result = service.call
        expect(result.errors).to be_an(Array)
        expect(result.errors).not_to be_empty
      end

      it 'includes the translated error message' do
        result = service.call
        expect(result.errors).to include(I18n.t('urls.show.error'))
      end

      it 'does not publish event' do
        service.call
        expect(ActiveSupport::Notifications).not_to have_received(:instrument)
      end
    end

    context 'with different short codes' do
      let(:url1) { instance_double(Url, id: 1, short_code: 'abc123', long_url: 'https://example1.com') }
      let(:url2) { instance_double(Url, id: 2, short_code: 'xyz789', long_url: 'https://example2.com') }

      before do
        allow(Url).to receive(:find_by).and_call_original
        allow(Url).to receive(:find_by).with(short_code: 'abc123').and_return(url1)
        allow(Url).to receive(:find_by).with(short_code: 'xyz789').and_return(url2)
        allow(ActiveSupport::Notifications).to receive(:instrument)
      end

      it 'finds the correct URL for the first short code' do
        result = described_class.new('abc123').call
        expect(result.value).to eq(url1)
      end

      it 'finds the correct URL for the second short code' do
        result = described_class.new('xyz789').call
        expect(result.value).to eq(url2)
      end

      it 'publishes correct event for first URL' do
        described_class.new('abc123').call
        expect(ActiveSupport::Notifications).to have_received(:instrument).with(
          "url.finded_enconded_url",
          id: 1,
          short_code: 'abc123',
          long_url: 'https://example1.com'
        )
      end

      it 'returns failure for a non-existent short code' do
        allow(Url).to receive(:find_by).with(short_code: 'nonexistent').and_return(nil)
        result = described_class.new('nonexistent').call
        expect(result.failure?).to be true
      end
    end

    context 'with edge cases' do
      before do
        allow(ActiveSupport::Notifications).to receive(:instrument)
      end

      it 'handles empty string short code' do
        allow(Url).to receive(:find_by).with(short_code: '').and_return(nil)
        result = described_class.new('').call
        expect(result.failure?).to be true
      end

      it 'handles nil short code' do
        allow(Url).to receive(:find_by).with(short_code: nil).and_return(nil)
        result = described_class.new(nil).call
        expect(result.failure?).to be true
      end

      it 'handles whitespace in short code' do
        allow(Url).to receive(:find_by).with(short_code: 'abc123 ').and_return(nil)
        result = described_class.new('abc123 ').call
        expect(result.failure?).to be true
      end
    end
  end
end
