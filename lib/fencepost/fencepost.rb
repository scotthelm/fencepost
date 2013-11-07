module Fencepost
  class Fencepost
    attr_reader :params, :model_list
    def initialize(hash)
      @model_list = {}
      @params = hash
      self.class.models.each do |model|
        model_list[param_key(model)] =
          {
          model: model,
          attributes: (),
          demodulized_name: demodulized_name(model),
          nested_collection_name: nested_collection_name(model),
          nested_attributes_name: nested_attributes_name(model),
          nested_attributes_options: nested_attributes_options(model)
        }
        define_singleton_method method_name(model) do |deny_list = nil|
        ActionController::Parameters.new(params).require(
          param_key(model)).permit(
            build_permits(model, []))
        end
      end
    end


    def self.models
      ActiveRecord::Base.descendants
    end

    def build_permits(model, permits_array)
      attribute_keys(model).each {|k| permits_array << k }
      nested_attributes_options(model).each do |nao, value|
        node = get_node(:nested_collection_name, nao)
        node = get_node(:demodulized_name, nao) if node.keys.size == 0
        node = node.values[0]
        permits_array << {node[:nested_attributes_name] => build_permits(node[:model], [])}
      end
      permits_array
    end

    def get_node(key, value)
      model_list.select {|k,v| v[key] == value}
    end

    private

    def method_name(model)
      "#{model.name.underscore.gsub("/", "_")}_params".to_sym
    end

    def param_key(model)
      "#{model.name.underscore.gsub("/", "_")}".to_sym
    end

    def demodulized_name(model)
      "#{model.name.demodulize.underscore.gsub("/", "_")}".to_sym
    end

    def nested_collection_name(model)
      "#{model.name.pluralize.demodulize.underscore.gsub("/", "_")}".to_sym
    end

    def nested_attributes_name(model)
      a ="#{model.name.pluralize.demodulize.underscore.gsub("/", "_")}_attributes"
      a.to_sym
    end

    def always_forbidden_attributes
      [:id, :created_at, :updated_at, :created_by, :updated_by]
    end

    def attribute_keys(model)
      a = model.new.attributes.keys.map {|k| k.to_sym} unless model.nil? || model.abstract_class
      (a || []) - always_forbidden_attributes
    end

    def nested_attributes_options(model)
      opts = model.nested_attributes_options
    end

  end
end
