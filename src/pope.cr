# NOTE: Pope.cr is the Crystal version of [Pope](https://github.com/poppinss/pope).
#
# A fast, minimal and micro template engine for strings only, it plays well where you want to embed micro templates inside your module.
#
#
module Pope
  VERSION = "0.1.0"

  class MissinPath < Exception
    def initialize
      super "Missing path."
    end
  end

  class InvalidFilter < Exception
    def initialize(filter_name : String?)
      super "Invalid filter: '#{filter_name}'"
    end
  end

  # The supported filters for template expressions.
  # For example:
  # ```
  # data = { name: "Monty Python" }
  # Pope.pope("Your name is {{name | upper}}")  # Your name is MONTY PYTHON
  # ```
  enum Filters
    Upper
    Lower

    def self.parse(input : String?)
      raise InvalidFilter.new(input) unless input

      case input.downcase
      when "upper" then Upper
      when "lower" then Lower
      else raise InvalidFilter.new(input)
      end
    end

    def apply(value)
      case self
      when Upper then value.to_s.upcase
      when Lower then value.to_s.downcase
      end
    end
  end

  # apply a series of filters to a given value, in order
  def self.apply_filters(value, filters : Array(Filters))
    filters.reduce(value) do |current, filter|
      filter.apply(current)
    end
  end

  # get nested properties from a given object using dot notation
  #
  # ```
  # data = {
  #   user: {
  #     id:       123,
  #     username: "krthr",
  #     admin:    true,
  #     config:   {
  #       email: "test@test.com",
  #     },
  #   },
  # }
  # Pope.prop(data, "user.id")           #  123
  # Pope.prop(data, "user.config.email") # test@test.com
  # Pope.prop(data, "nananana")          # nil
  # ```
  def self.prop(obj : NamedTuple | Hash, path : String = "")
    raise MissinPath.new unless path.strip != ""

    props = path.strip.split(".")

    i = 0
    while i < props.size && !obj.nil?
      prop = props[i]
      obj = obj.responds_to?(:[]?) ? obj[prop]? : nil
      i += 1
    end

    obj
  end

  # parses a given template string and replace dynamic placeholders with actual data.
  #
  # ```
  # data = {
  #   user: {
  #     id:       123,
  #     username: "krthr",
  #     admin:    true,
  #     config:   {
  #       email: "test@test.com",
  #     },
  #   },
  # }
  # Pope.pope(
  #   "The user {{user.username}} with id {{user.id}} is cool",
  #   data
  # ) # "The user krthr with id 123 is cool"
  # ```
  def self.pope(
    string : String,
    data : NamedTuple,
    opts = {
      skip_undefined:     false,
      throw_on_undefined: false,
    }
  )
    # Grab out all template expressions to evaluate and replace
    string.gsub(/{{2}(.+?)}{2}/) do |str, match|
      expression = match[1]
      # Look for any pipeline filters that may be applied
      path_and_all_filters = expression.split("|")
      path = path_and_all_filters[0]
      filters = 
        if path_and_all_filters.size > 1 
          path_and_all_filters.skip(1).map(&.strip).map {|it| Filters.parse(it)}
        else
          [] of Filters
        end

      val = self.prop(data, path)

      if val.nil?
        if opts[:throw_on_undefined]
          raise "Missing value for #{path}"
        end

        if opts[:skip_undefined]
          next str # if we didn't find the value, but we're supposed to skip unresolved values, then don't apply filters either.
        end
      end

      self.apply_filters(val, filters)
    end
  end
end
