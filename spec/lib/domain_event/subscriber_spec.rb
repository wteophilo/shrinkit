require 'rails_helper'

RSpec.describe DomainEvent::Subscriber do
  let(:dummy_class) { Class.new { include DomainEvent::Subscriber } }

  describe ".included" do
    it "extends the base class with ClassMethods" do
      expect(dummy_class).to respond_to(:handles_event)
      expect(dummy_class).to respond_to(:event_name)
    end
  end

  describe ".handles_event" do
    it "sets the event name" do
      dummy_class.handles_event("test_event")
      expect(dummy_class.event_name).to eq "test_event"
    end

    it "adds the class to the registry" do
      allow(DomainEvent).to receive(:registry).and_return([])
      dummy_class.handles_event("test_event")
      expect(DomainEvent.registry).to include(dummy_class)
    end
  end

  describe ".event_name" do
    it "returns the stored event name" do
      dummy_class.instance_variable_set(:@event_name, "stored_event")
      expect(dummy_class.event_name).to eq "stored_event"
    end
  end
end

describe DomainEvent do
  describe ".registry" do
    it "returns an array" do
      expect(DomainEvent.registry).to be_an(Array)
    end

    it "memoizes the registry" do
      registry = DomainEvent.registry
      expect(DomainEvent.registry).to be registry
    end
  end
end
