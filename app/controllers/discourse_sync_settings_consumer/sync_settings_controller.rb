module DiscourseSyncSettingsConsumer
  class SyncSettingsController < ::ApplicationController

    def retrieveSettings
      shareable_settings = params["shareable_settings"]

      consumer_settings = SiteSetting.current.keys;

      site_settings(shareable_settings).each do |key, value|
        if consumer_settings.include?(key.to_sym)
          begin
            SiteSetting.set(key.to_sym, value)
          rescue => e
            Rails.logger.error("Error From SyncSettings pluging when Changing the Setting: #{key}. Message: #{e.message}")
          end
        end
      end

      shareable_settings["embeddable_hosts"].each do |embeddable_host|
        found_embeddable_host = EmbeddableHost.find_by(host: embeddable_host["host"])
        unless found_embeddable_host
          EmbeddableHost.create(host: embeddable_host["host"], category_id: embeddable_host["category_id"])
        end
      end

      obj = {answer: "Done"}
      render json: obj
    end

    private
    def site_settings(shareable_settings)
      sitesettings = shareable_settings["site_settings"]
      sitesettings.except(*sync_settings_names)
    end

    def sync_settings_names
      [:sync_settings_production_host,
        :sync_settings_production_api_key,
        :sync_settings_production_admin_username,
        :sync_settings_unsync_settings]
    end
  end
end
