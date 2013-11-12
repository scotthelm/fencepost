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
      hash_values(allow_array).each do |hash_value|
        perms = nested_operations(perms, hash_value, :+)
      end
      perms + scalar_values(allow_array)
    end

    def deny_permissions(perms)
      hash_values(deny_array).each do |hash_value|
        perms = nested_operations(perms, hash_value, :-)
      end
      perms - scalar_values(deny_array)
    end

    def scalar_values(arry)
      arry.select{|x| x.is_a?(String) || x.is_a?(Symbol)}
    end

    def hash_values(arry)
      arry.select{|x| x.is_a?(Hash)}
    end

    def nested_operations(perms, hash, operator)
      perms.each do |perm|
        hash.each do |key, value|
          set_permission_value(perm, key, value, operator)
        end
      end
    end

    def set_permission_value(perm, key, value, operator)
      if perm.is_a?(Hash) && perm.keys.index(key) && perm[key].is_a?(Array)
        perm[key] = perm[key].send(operator, value)
        recurse_permissions(perm, key, value, operator)
      end
    end

    def recurse_permissions(perm, key, value, operator)
      hash_values(perm[key]).each do |pk|
        hash_values(value).each do |hk|
          set_permission_value(pk, hk.keys[0], hk.values[0], operator)
        end
      end
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
