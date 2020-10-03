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
    raise MissinPath.new unless path != ""

    props = path.split(".")

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
    string.gsub(/{{2}(.+?)}{2}/) do |str, match|
      path = match[1]

      val = self.prop(data, path)

      if val.nil?
        if opts[:throw_on_undefined]
          raise "Missing value for #{path}"
        end

        if opts[:skip_undefined]
          val = str
        end
      end

      val
    end
  end
end
