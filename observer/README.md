# The Observer Pattern

The observer pattern is useful when you need to notify different objects (called observers) of the events happening in a particular (the observable) object.

It's similar to how subscriptions work. For example, if you were to subscribe to a newspaper, each time a new paper would be published, you would get a copy of it.

## How does it work?

The observable object can *push* notifications to its observers as follows.

1. The observable object needs a way for other objects to register themselves as observers.

2. When the observable object wants to, it can notify it's observers of a particular event that has occurred.

3. Observers need to adhere to a specific interface, meaning they need to respond to the method that the observer object will call. The observer object will assume that whoever is listening will know how to respond to the the method it calls.

4. Each observer will then perform actions in response to the received notification.

## Example

Here is an example of the observer pattern in action. We have an object that emits events when some it receives messages (when its methods are called), and it sends a message to a subscription manager object.

The subscription manager object is responsible for receiving the notification message from the event emitter, and sending it to all its subscribers. It is also responsible for managing subscriptions.

In this particular example, subscribers can subscribe to particular messages. They don't have to receive all the messages that are sent through the subscription manager.

```ruby
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

```

## Output

```
A needs to handle this payload: me@example.com
B needs to handle this payload: 123456789
```

## Exercises

## Exercise 1 - The Apple Store

A new iPhone has just been released by Apple, but the only Apple Store in town doesn't have it yet.

John and Marcus being the Apple fanboys that they are, cannot wait for a re-stock. So instead of making them visit the store every day to see if the new model has arrived in stock, we want to help them by sending them a notification when the store is restocked with the new iPhone model.

## Exercise 2 - Exception logging

Our application needs to use a centralized logger, and we want to be able to be able to send exceptions to it. And the logger would then send an email to the users that are interested in receiving  those notifications.

