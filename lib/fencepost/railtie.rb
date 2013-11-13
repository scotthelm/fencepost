require 'yaml'
module Fencepost
  class Railtie < ::Rails::Railtie
    config.after_initialize do
      Rails.application.eager_load!
      file_name = "#{Rails.root}/config/fencepost.yml"
      Fencepost.model_list = YAML.load_file(file_name) if File.exists?(file_name)
    end
  end
end
