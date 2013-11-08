require 'yaml'

class FencepostConfigGenerator < Rails::Generators::Base
  def create_initializer_file
    Rails.application.eager_load!
    create_file "config/initializers/fencepost.rb",
      file_contents
  end

  def file_contents
<<-yaml
Rails.application.eager_load!
Fencepost::Fencepost.model_list = YAML.load(
<<-contents
#{Fencepost::Fencepost.generate_model_list.to_yaml}
contents
)
yaml
  end
end
