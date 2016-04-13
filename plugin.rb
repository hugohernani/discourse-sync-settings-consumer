# name: site-settings-sync-consumer
# about: Plugin for receiving settings through plugin in the other discourse side
# version: 0.0.1
# authors: Quezmedia

enabled_site_setting :sync_settings_consumer_enabled

# load the engine
load File.expand_path('../lib/discourse_sync_settings_consumer/engine.rb', __FILE__)

after_initialize do
  Discourse::Application.routes.append do
    mount ::DiscourseSyncSettingsConsumer::Engine, at: "sync_settings"
  end
end
