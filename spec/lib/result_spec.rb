require 'rails_helper'

RSpec.describe Result do
  describe '#success?' do
    it 'returns true for a success result' do
      result = Result.success('value')
      expect(result.success?).to be true
    end

    it 'returns false for a failure result' do
      result = Result.failure('error')
      expect(result.success?).to be false
    end
  end

  describe '#failure?' do
    it 'returns true for a failure result' do
      result = Result.failure('error')
      expect(result.failure?).to be true
    end

    it 'returns false for a success result' do
      result = Result.success('value')
      expect(result.failure?).to be false
    end
  end

  describe '.success' do
    it 'creates a success result with the given value' do
      result = Result.success('value')
      expect(result.success?).to be true
      expect(result.value).to eq 'value'
      expect(result.errors).to be nil
    end
  end

  describe '.failure' do
    it 'creates a failure result with the given errors' do
      result = Result.failure('error')
      expect(result.failure?).to be true
      expect(result.errors).to eq 'error'
      expect(result.value).to be nil
    end
  end
end
