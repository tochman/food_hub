# Be sure to restart your server when you modify this file.

ActiveSupport::Reloader.to_prepare do
   ApplicationController.renderer.defaults.merge!(
     http_host: 'f3213182.ngrok.io',
     https: true
   )
 end
