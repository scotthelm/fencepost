module Fencepost
  class Fencepost
    attr_reader :gate
    cattr_accessor :model_list
    def initialize(params)
      ensure_models
      @gate = Gate.new(self.class.model_list, params)
      self.class.models.each do |model|
        define_singleton_method self.class.method_name(model) do
          gate.open(params,self.class.param_key(model), model)
        end
      end
    end

    def self.models
      ActiveRecord::Base.descendants - [ActiveRecord::SchemaMigration]
    end

    def self.generate_model_list
      model_list = {}
      models.each do |model|
        model_list[self.param_key(model)] =
        {
          model: model,
          attributes: self.attribute_keys(model),
          demodulized_name: self.demodulized_name(model),
          nested_collection_name: self.nested_collection_name(model),
          nested_attributes_name: self.nested_attributes_name(model),
          nested_attributes_options: self.nested_attributes_options(model),
          nested_singular_name: self.nested_singular_attributes_name(model)
        }
      end

      model_list
    end

    def ensure_models
      Rails.application.eager_load!
      klass = self.class
      if ::Fencepost.configuration.dev_mode
        klass.model_list = klass.generate_model_list
      end
    end

    def allow(elements)
      gate.allow(elements)
      self
    end

    def deny(elements)
      gate.deny(elements)
      self
    end

    private

    def self.method_name(model)
      "#{model.name.underscore.gsub("/", "_")}_params".to_sym
    end

    def self.param_key(model)
      "#{model.name.underscore.gsub("/", "_")}".to_sym
    end

    def self.demodulized_name(model)
      "#{model.name.demodulize.underscore.gsub("/", "_")}".to_sym
    end

    def self.nested_collection_name(model)
      "#{model.name.pluralize.demodulize.underscore.gsub("/", "_")}".to_sym
    end

    def self.nested_attributes_name(model)
      a ="#{model.name.pluralize.demodulize.underscore.gsub("/", "_")}_attributes"
      a.to_sym
    end

    def self.nested_singular_attributes_name(model)
      a ="#{model.name.demodulize.underscore.gsub("/", "_")}_attributes"
      a.to_sym
    end

    def self.always_forbidden_attributes
      []
    end

    def self.attribute_keys(model)
      begin
        a = model.new.attributes.keys.map {|k| k.to_sym} unless model.nil? || model.abstract_class
        (a || []) - self.always_forbidden_attributes
      rescue
        []
      end
    end

    def self.nested_attributes_options(model)
      model.nested_attributes_options
    end

  end
end
