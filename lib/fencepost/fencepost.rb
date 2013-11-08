module Fencepost
  class Fencepost
    attr_reader :params
    cattr_accessor :model_list
    def initialize(hash)
      @params = hash
      self.class.models.each do |model|
        define_singleton_method self.class.method_name(model) do |deny_list = nil|
        ActionController::Parameters.new(params).require(
          self.class.param_key(model)).permit(
            build_permits(model, []))
        end
      end
    end

    def self.models
      ActiveRecord::Base.descendants
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
          nested_attributes_options: self.nested_attributes_options(model)
        }
      end

      model_list
    end

    def build_permits(model, permits_array)
      model_attributes(model).each {|k| permits_array << k }
      model_nested_attributes(model).each do |nao, value|
        node = get_node(:nested_collection_name, nao)
        node = get_node(:demodulized_name, nao) if node.keys.size == 0
        node = node.values[0]
        permits_array << {node[:nested_attributes_name] => build_permits(node[:model], [])}
      end
      permits_array
    end

    def get_node(key, value)
      self.model_list.select {|k,v| v[key] == value}
    end

    def model_attributes(model)
      get_node(:model, model).values[0][:attributes]
    end

    def model_nested_attributes(model)
      get_node(:model, model).values[0][:nested_attributes_options]
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

    def self.always_forbidden_attributes
      [:id, :created_at, :updated_at, :created_by, :updated_by]
    end

    def self.attribute_keys(model)
      a = model.new.attributes.keys.map {|k| k.to_sym} unless model.nil? || model.abstract_class
      (a || []) - self.always_forbidden_attributes
    end

    def self.nested_attributes_options(model)
      model.nested_attributes_options
    end

  end
end
