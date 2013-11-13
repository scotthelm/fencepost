require 'yaml'

class FencepostConfigGenerator < Rails::Generators::Base
  def create_initializer_file
    Rails.application.eager_load!
    create_file "config/initializers/fencepost.rb", config_contents
    create_file "config/fencepost.yml", yaml_contents
  end

  def config_contents
<<-config
Rails.application.eager_load!
Fencepost.configure do |config|
  # dev_mode true means that the Fencepost model_list is created every time
  # a Fencepost is created. This allows you to have Fencepost read your models
  # dynamically rather than having to generate a new yaml file every time you
  # want to change your models. Once your models have stabilized, however. You
  # should set this to false and run bundle exec rails g fencepost_config for
  # a performance gain (having the model graph as a class variable rather than
  # creating it from scratch every time)
  config.dev_mode = false
end
config
  end

  def yaml_contents
<<-yaml
#{Fencepost::Fencepost.generate_model_list.to_yaml}
yaml
  end
end
