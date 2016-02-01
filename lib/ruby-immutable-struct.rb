module RubyImmutableStruct
  def self.new(*attributes, &block)
    attributes = attributes.map(&:to_sym)

    if !attributes.all? { |a| a.to_s =~ /^[_a-z][_a-zA-Z0-9_]*/ }
      raise "ImmutableStruct only allows attributes that look like Ruby variables: /[_a-z][a-zA-Z0-9_]*/. That keeps things fast and simple."
    end

    klass = Class.new do
      attr_reader(*attributes)

      class_eval <<-EOT
        def initialize(*args)
          if args[0].is_a?(Hash)
            hash = args[0]
            #{attributes.map{ |a| "@#{a} = hash[:#{a}]" }.join(';')}
          else
            #{attributes.map.with_index{ |a, i| "@#{a} = args[#{i}]" }.join(';')}
          end

          freeze
        end

        def merge(hash)
          merged_hash = to_h.merge!(hash)
          self.class.new(merged_hash)
        end

        def to_h
          { #{attributes.map{ |a| "#{a}: @#{a}" }.join(',')} }
        end

        def to_a
          [ #{attributes.map{ |a| "@#{a}" }.join(',')} ]
        end

        def inspect
          "#<#\{self.class.name} #\{to_a.map(&:inspect).join(',')}>"
        end

        def to_s
          inspect
        end
      EOT
    end

    klass.class_exec(&block) if !block.nil?

    klass
  end
end
