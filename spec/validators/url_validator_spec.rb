require 'rails_helper'

# Dummy class to test the custom validator in isolation
class Validatable
  include ActiveModel::Model
  attr_accessor :long_url
  validates :long_url, url: true
end

RSpec.describe UrlValidator do
  subject { Validatable.new(long_url: url) }

  describe 'protocol validation' do
    context 'with valid protocols' do
      %w[http://google.com https://rails.org].each do |valid_url|
        let(:url) { valid_url }
        it { is_expected.to be_valid }
      end
    end

    context 'with invalid or malicious protocols' do
      %w[ftp://files.com javascript:alert(1) data:text/html].each do |invalid_url|
        let(:url) { invalid_url }
        it "rejects #{invalid_url}" do
          expect(subject).not_to be_valid
          expect(subject.errors[:long_url]).to include(I18n.t('errors.messages.invalid_protocol'))
        end
      end
    end
  end

  describe 'host validation' do
    context 'when host is too short' do
      let(:url) { 'https://a.b' }
      it { is_expected.not_to be_valid }
    end

    context 'when host lacks a TLD (no dot)' do
      let(:url) { 'https://localhost' }
      it { is_expected.not_to be_valid }
    end

    context 'when host is missing' do
      let(:url) { 'https://' }
      it { is_expected.not_to be_valid }
    end
  end

  describe 'format errors' do
    let(:url) { 'invalid-url-format' }
    it 'adds the invalid_url_format error' do
      expect(subject).not_to be_valid
    end
  end
end
