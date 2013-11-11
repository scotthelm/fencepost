module Fencepost
  class Gate
    attr_reader :allow_array, :deny_array, :model_list, :model
    def initialize(model_list, params)
      @allow_array = []
      @deny_array = []
      @model_list = model_list
      @model = model
    end

    def open(params, key, model)
      perms = deny_permissions(allow_permissions(build_permits(model, [])))
      ActionController::Parameters.new(params).require(key).permit(perms)
    end

    def allow(*elements)
      @allow_array += elements
      self
    end

    def deny(*elements)
      @deny_array += elements
      self
    end

    def allow_permissions(perms)
      perms + allow_array
    end

    def deny_permissions(perms)
      perms - deny_array
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

    def model_attributes(model)
      get_node(:model, model).values[0][:attributes]
    end

    def model_nested_attributes(model)
      get_node(:model, model).values[0][:nested_attributes_options]
    end

    def get_node(key, value)
      self.model_list.select {|k,v| v[key] == value}
    end

  end
end
