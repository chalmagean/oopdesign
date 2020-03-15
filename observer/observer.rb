class EventEmitter
  def initialize(subscription_manager)
    @subscription_manager = subscription_manager
  end

  def email_notification(email)
    subscription_manager.notify(:email, email)
  end

  def sms_notification(number)
    subscription_manager.notify(:sms, number)
  end

  private

    attr_reader :subscription_manager
end

class SubscriptionManager
  def initialize
    @listeners = {}
  end

  def subscribe(event_type, listener)
    listeners[event_type] = [] unless listeners[event_type]

    listeners[event_type] << listener
  end

  def unsubscribe(event_type, listener)
    return unless listeners[event_type]

    listeners[event_type].delete(listener)
  end

  def notify(event_type, data)
    listeners.fetch(event_type, []).each do |listener|
      listener.update(data)
    end
  end

  private

    attr_reader :listeners
end

class SubscriberA
  def update(data)
    puts "A needs to handle this payload: #{data}"
  end
end

class SubscriberB
  def update(data)
    puts "B needs to handle this payload: #{data}"
  end
end

subscriber_a = SubscriberA.new
subscriber_b = SubscriberB.new
subscription_manager = SubscriptionManager.new
subscription_manager.subscribe(:email, subscriber_a)
subscription_manager.subscribe(:sms, subscriber_b)

event_emitter = EventEmitter.new(subscription_manager)
event_emitter.email_notification("me@example.com")
event_emitter.sms_notification("123456789")
