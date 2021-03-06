# Copyright 2018 Google, Inc
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require "google/cloud/pubsub"

def create_topic topic_name:
  # [START pubsub_create_topic]
  # topic_name = "Your Pubsub topic name"
  require "google/cloud/pubsub"

  pubsub = Google::Cloud::Pubsub.new

  topic = pubsub.create_topic topic_name

  puts "Topic #{topic.name} created."
  # [END pubsub_create_topic]
end

def list_topics
  # [START pubsub_list_topics]
  require "google/cloud/pubsub"

  pubsub = Google::Cloud::Pubsub.new

  topics = pubsub.topics

  puts "Topics in project:"
  topics.each do |topic|
    puts topic.name
  end
  # [END pubsub_list_topics]
end

def list_topic_subscriptions topic_name:
  # [START pubsub_list_topic_subscriptions]
  # topic_name = "Your Pubsub topic name"
  require "google/cloud/pubsub"

  pubsub = Google::Cloud::Pubsub.new

  topic         = pubsub.topic topic_name
  subscriptions = topic.subscriptions

  puts "Subscriptions in topic #{topic.name}:"
  subscriptions.each do |subscription|
    puts subscription.name
  end
  # [END pubsub_list_topic_subscriptions]
end

def delete_topic topic_name:
  # [START pubsub_delete_topic]
  # topic_name = "Your Pubsub topic name"
  require "google/cloud/pubsub"

  pubsub = Google::Cloud::Pubsub.new

  topic = pubsub.topic topic_name
  topic.delete

  puts "Topic #{topic_name} deleted."
  # [END pubsub_delete_topic]
end

def get_topic_policy topic_name:
  # [START pubsub_get_topic_policy]
  # topic_name = "Your Pubsub topic name"
  require "google/cloud/pubsub"

  pubsub = Google::Cloud::Pubsub.new

  topic  = pubsub.topic topic_name
  policy = topic.policy

  puts "Topic policy:"
  puts policy.roles
  # [END pubsub_get_topic_policy]
end

def set_topic_policy topic_name:, role:, service_account_email:
  # [START pubsub_set_topic_policy]
  # topic_name = "Your Pubsub topic name"
  # role = "roles/pubsub.publisher"
  # service_account_email = "serviceAccount:account_name@project_name.iam.gserviceaccount.com"
  require "google/cloud/pubsub"

  pubsub = Google::Cloud::Pubsub.new

  topic = pubsub.topic topic_name
  topic.policy do |policy|
    policy.add role, service_account_email
  end
  # [END pubsub_set_topic_policy]
end

def test_topic_permissions topic_name:
  # [START pubsub_test_topic_permissions]
  # topic_name = "Your Pubsub topic name"
  require "google/cloud/pubsub"

  pubsub = Google::Cloud::Pubsub.new

  topic       = pubsub.topic topic_name
  permissions = topic.test_permissions "pubsub.topics.attachSubscription",
                                       "pubsub.topics.publish", "pubsub.topics.update"

  puts "Permission to attach subscription" if permissions.include? "pubsub.topics.attachSubscription"
  puts "Permission to publish" if permissions.include? "pubsub.topics.publish"
  puts "Permission to update" if permissions.include? "pubsub.topics.update"
  # [END pubsub_test_topic_permissions]
end

def create_pull_subscription topic_name:, subscription_name:
  # [START pubsub_create_pull_subscription]
  # topic_name        = "Your Pubsub topic name"
  # subscription_name = "Your Pubsub subscription name"
  require "google/cloud/pubsub"

  pubsub = Google::Cloud::Pubsub.new

  topic        = pubsub.topic topic_name
  subscription = topic.subscribe subscription_name

  puts "Pull subscription #{subscription_name} created."
  # [END pubsub_create_pull_subscription]
end

def create_ordered_pull_subscription topic_name:, subscription_name:
  # [START pubsub_enable_subscription_ordering]
  # topic_name        = "Your Pubsub topic name"
  # subscription_name = "Your Pubsub subscription name"
  require "google/cloud/pubsub"

  pubsub = Google::Cloud::Pubsub.new

  topic        = pubsub.topic topic_name
  subscription = topic.subscribe subscription_name,
                                 message_ordering: true

  puts "Pull subscription #{subscription_name} created with message ordering."
  # [END pubsub_enable_subscription_ordering]
end

def create_push_subscription topic_name:, subscription_name:, endpoint:
  # [START pubsub_create_push_subscription]
  # topic_name        = "Your Pubsub topic name"
  # subscription_name = "Your Pubsub subscription name"
  # endpoint          = "Endpoint where your app receives messages"
  require "google/cloud/pubsub"

  pubsub = Google::Cloud::Pubsub.new

  topic        = pubsub.topic topic_name
  subscription = topic.subscribe subscription_name,
                                 endpoint: endpoint

  puts "Push subscription #{subscription_name} created."
  # [END pubsub_create_push_subscription]
end

def publish_message topic_name:
  # [START pubsub_quickstart_publisher]
  # topic_name = "Your Pubsub topic name"
  require "google/cloud/pubsub"

  pubsub = Google::Cloud::Pubsub.new

  topic = pubsub.topic topic_name
  topic.publish "This is a test message."

  puts "Message published."
  # [END pubsub_quickstart_publisher]
end

def publish_message_async topic_name:
  # [START pubsub_publish]
  # topic_name = "Your Pubsub topic name"
  require "google/cloud/pubsub"

  pubsub = Google::Cloud::Pubsub.new

  topic = pubsub.topic topic_name
  topic.publish_async "This is a test message." do |result|
    raise "Failed to publish the message." unless result.succeeded?
    puts "Message published asynchronously."
  end

  # Stop the async_publisher to send all queued messages immediately.
  topic.async_publisher.stop.wait!
  # [END pubsub_publish]
end

def publish_message_async_with_custom_attributes topic_name:
  # [START pubsub_publish_custom_attributes]
  # topic_name = "Your Pubsub topic name"
  require "google/cloud/pubsub"

  pubsub = Google::Cloud::Pubsub.new

  topic = pubsub.topic topic_name
  # Add two attributes, origin and username, to the message
  topic.publish_async "This is a test message.",
                      origin:   "ruby-sample",
                      username: "gcp" do |result|
    raise "Failed to publish the message." unless result.succeeded?
    puts "Message with custom attributes published asynchronously."
  end

  # Stop the async_publisher to send all queued messages immediately.
  topic.async_publisher.stop.wait!
  # [END pubsub_publish_custom_attributes]
end

def publish_messages_async_with_batch_settings topic_name:
  # [START pubsub_publisher_batch_settings]
  # topic_name = "Your Pubsub topic name"
  require "google/cloud/pubsub"

  pubsub = Google::Cloud::Pubsub.new

  # Start sending messages in one request once the size of all queued messages
  # reaches 1 MB or the number of queued messages reaches 20
  topic = pubsub.topic topic_name, async: {
    max_bytes:    1_000_000,
    max_messages: 20
  }
  10.times do |i|
    topic.publish_async "This is message \##{i}."
  end

  # Stop the async_publisher to send all queued messages immediately.
  topic.async_publisher.stop.wait!
  puts "Messages published asynchronously in batch."
  # [END pubsub_publisher_batch_settings]
end

def publish_messages_async_with_concurrency_control topic_name:
  # [START pubsub_publisher_concurrency_control]
  # topic_name = "Your Pubsub topic name"
  require "google/cloud/pubsub"

  pubsub = Google::Cloud::Pubsub.new

  topic = pubsub.topic topic_name, async: {
    threads: {
      # Use exactly one thread for publishing message and exactly one thread
      # for executing callbacks
      publish:  1,
      callback: 1
    }
  }
  topic.publish_async "This is a test message." do |result|
    raise "Failed to publish the message." unless result.succeeded?
    puts "Message published asynchronously."
  end

  # Stop the async_publisher to send all queued messages immediately.
  topic.async_publisher.stop.wait!
  # [END pubsub_publisher_concurrency_control]
end

def publish_ordered_messages topic_name:
  # [START pubsub_publish_with_ordering_keys]
  # topic_name = "Your Pubsub topic name"
  require "google/cloud/pubsub"

  pubsub = Google::Cloud::Pubsub.new

  # Start sending messages in one request once the size of all queued messages
  # reaches 1 MB or the number of queued messages reaches 20
  topic = pubsub.topic topic_name, async: {
    max_bytes:    1_000_000,
    max_messages: 20
  }
  topic.enable_message_ordering!
  10.times do |i|
    topic.publish_async "This is message \##{i}.",
                        ordering_key: "ordering-key"
  end

  # Stop the async_publisher to send all queued messages immediately.
  topic.async_publisher.stop!
  puts "Messages published with ordering key."
  # [END pubsub_publish_with_ordering_keys]
end

def publish_resume_publish topic_name:
  # [START pubsub_resume_publish_with_ordering_keys]
  # topic_name = "Your Pubsub topic name"
  require "google/cloud/pubsub"

  pubsub = Google::Cloud::Pubsub.new

  # Start sending messages in one request once the size of all queued messages
  # reaches 1 MB or the number of queued messages reaches 20
  topic = pubsub.topic topic_name, async: {
    max_bytes:    1_000_000,
    max_messages: 20
  }
  topic.enable_message_ordering!
  10.times do |i|
    topic.publish_async "This is message \##{i}.",
                        ordering_key: "ordering-key" do |result|
      if result.succeeded?
        puts "Message \##{i} successfully published."
      else
        puts "Message \##{i} failed to publish"
        # Allow publishing to continue on "ordering-key" after processing the
        # failure.
        topic.resume_publish "ordering-key"
      end
    end
  end

  # Stop the async_publisher to send all queued messages immediately.
  topic.async_publisher.stop!
  # [END pubsub_resume_publish_with_ordering_keys]
end

if $PROGRAM_NAME == __FILE__
  case ARGV.shift
  when "create_topic"
    create_topic topic_name: ARGV.shift
  when "list_topics"
    list_topics
  when "list_topic_subscriptions"
    list_topic_subscriptions topic_name: ARGV.shift
  when "delete_topic"
    delete_topic topic_name: ARGV.shift
  when "get_topic_policy"
    get_topic_policy topic_name: ARGV.shift
  when "set_topic_policy"
    set_topic_policy topic_name: ARGV.shift, role: ARGV.shift, service_account_email: ARGV.shift
  when "test_topic_permissions"
    test_topic_permissions topic_name: ARGV.shift
  when "create_pull_subscription"
    create_pull_subscription topic_name:        ARGV.shift,
                             subscription_name: ARGV.shift
  when "create_ordered_pull_subscription"
    create_ordered_pull_subscription topic_name:        ARGV.shift,
                                     subscription_name: ARGV.shift
  when "create_push_subscription"
    create_push_subscription topic_name:        ARGV.shift,
                             subscription_name: ARGV.shift,
                             endpoint:          ARGV.shift
  when "publish_message"
    publish_message topic_name: ARGV.shift
  when "publish_message_async"
    publish_message_async topic_name: ARGV.shift
  when "publish_message_async_with_custom_attributes"
    publish_message_async_with_custom_attributes topic_name: ARGV.shift
  when "publish_messages_async_with_batch_settings"
    publish_messages_with_batch_settings topic_name: ARGV.shift
  when "publish_messages_async_with_concurrency_control"
    publish_messages_async_with_concurrency_control topic_name: ARGV.shift
  when "publish_ordered_messages"
    publish_ordered_messages topic_name: ARGV.shift
  when "publish_resume_publish"
    publish_resume_publish topic_name: ARGV.shift
  else
    puts <<~USAGE
      Usage: bundle exec ruby topics.rb [command] [arguments]

      Commands:
        create_topic                                    <topic_name>                     Create a topic
        list_topics                                                                      List topics in a project
        list_topic_subscriptions                        <topic_name>                     List subscriptions in a topic
        delete_topic                                    <topic_name>                     Delete topic policies
        get_topic_policy                                <topic_name>                     Get topic policies
        set_topic_policy                                <topic_name> <role> <service_account_email>                    Set topic policies
        test_topic_permissions                          <topic_name>                     Test topic permissions
        create_pull_subscription                        <topic_name> <subscription_name> Create a pull subscription
        create_ordered_pull_subscription                <topic_name> <subscription_name> Create a pull subscription with ordering enabled
        create_push_subscription                        <topic_name> <subscription_name> <endpoint> Create a push subscription
        publish_message                                 <topic_name>                     Publish message
        publish_message_async                           <topic_name>                     Publish messages asynchronously
        publish_message_async_with_custom_attributes    <topic_name>                     Publish messages asynchronously with custom attributes
        publish_messages_async_with_batch_settings      <topic_name>                     Publish messages asynchronously in batch
        publish_messages_async_with_concurrency_control <topic_name>                     Publish messages asynchronously with concurrency control
        publish_ordered_messages                        <topic_name>                     Publish messages asynchronously with ordering keys
        publish_resume_publish                          <topic_name>                     Publish messages asynchronously with ordering keys and resume on failure
    USAGE
  end
end
