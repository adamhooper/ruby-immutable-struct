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
          # args.length == 1 is faster than args[0].is_a?(Hash). So check it
          # first -- speed demons won't be using hashes, so let's save them the
          # is_a? call.
          if args.length == 1 && args[0].is_a?(Hash)
            hash = args[0]
            #{attributes.map{ |a| "@#{a} = hash[:#{a}]" }.join(';')}
          else
            #{attributes.map.with_index{ |a, i| "@#{a} = args[#{i}]" }.join(';')}
          end

          after_initialize

          freeze
        end

        def after_initialize
          # Implementations may override this
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

        def ==(other)
          #{attributes.map{ |a| "@#{a} == other.#{a}" }.join(' && ')}
        end
        alias :eql? :==

        def hash
          to_a.hash
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
