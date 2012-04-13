module Mongoid
  module Matchers
    module Document
      class HaveFieldMatcher
        include Mongoid::Matchers::Helpers

        def initialize(*fields)
          @fields = fields.collect(&:to_s)
        end

        def of_type(type)
          @type = type
          self
        end

        def with_default_value(default)
          @default = default
          self
        end

        def matches?(klass)
          @klass  = klass.is_a?(Class) ? klass : klass.class
          @errors = []

          @fields.each do |field|
            if @klass.fields.include?(field)
              error = ""
              result_field = @klass.fields[field]
              
              if @type && result_field.type != @type
                error << " of type #{result_field.type.inspect}"
              end

              if !@default.nil? && !result_field.default.nil? && result_field.default != @default
                error << " with default value of #{result_field.default.inspect}"
              end

              @errors << "field #{field.inspect << error}" if !error.blank?
            else
              @errors << "no field named #{field.inspect}"
            end
          end

          @errors.empty?
        end

        def failure_message
          "#{@klass.inspect} to #{description}, got #{@errors.to_sentence}"
        end

        def negative_failure_message
          msg =  "#{@klass.inspect} to not #{description}, "
          msg << "got #{@klass.inspect} to #{description}"
        end

        def description
          desc =  "have #{@fields.size > 1 ? 'fields' : 'field'} named"
          desc << " #{to_sentence(@fields)}"
          desc << " of type #{@type.inspect}" if @type
          desc << " with default value of #{@default.inspect}" if !@default.nil?
          desc
        end
      end

      def have_field(*fields)
        HaveFieldMatcher.new(*fields)
      end
      alias :have_fields :have_field

    end
  end
end
