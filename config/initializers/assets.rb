# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'
# View specifics
Rails.application.config.assets.precompile += %w( playlist.js playlist.css )
# Partials
Rails.application.config.assets.precompile += %w( search_area.js search_area.css )
Rails.application.config.assets.precompile += %w( playlist_area.js playlist_area.css )
# Externals
Rails.application.config.assets.precompile += %w( animate.css )

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
