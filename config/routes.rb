DiscourseSyncSettingsConsumer::Engine.routes.draw do
	post '/retrieve_discourse_settings' => 'sync_settings#retrieveSettings'
end
