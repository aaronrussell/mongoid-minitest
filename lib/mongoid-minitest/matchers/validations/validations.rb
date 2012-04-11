module Mongoid
  module Matchers
    module Validations
      class HaveValidationMatcher
        def initialize(field, validation_type)
          @field = field.to_s
          @type = validation_type.to_s
        end

        def matches?(actual)
          @klass = actual.is_a?(Class) ? actual : actual.class
          @validator = @klass.validators_on(@field).detect { |v| v.kind.to_s == @type }

          if @validator
            @negative_message = "#{@type.inspect} validator on #{@field.inspect}"
            @positive_message = "#{@type.inspect} validator on #{@field.inspect}"
          else
            @negative_message = "no #{@type.inspect} validator on #{@field.inspect}"
            return false
          end

          true
        end

        def failure_message
          "Expected #{@klass.inspect} to #{description}; instead got #{@negative_message}"
        end

        def negative_failure_message
          "Expected #{@klass.inspect} to not #{description}; instead got #{@positive_message}"
        end

        def description
          "validate #{@type.inspect} of #{@field.inspect}"
        end
      end
    end
  end
end