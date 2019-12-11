crystal_doc_search_index_callback({"repository_name":"","body":"# Pope.cr\n\n> A Crystal version of [Pope](https://github.com/poppinss/pope)\n\nA fast, minimal and micro template engine for strings only, it plays well where you want to embed micro templates inside your module.\n\n## Installation\n\n1. Add the dependency to your `shard.yml`:\n\n   ```yaml\n   dependencies:\n     strint.cr:\n       github: krthr/pope.cr\n   ```\n\n2. Run `shards install`\n\n## Usage\n\n```crystal\nrequire \"pope.cr\"\n\ndata = {\n  user: {\n    id:       123,\n    username: \"krthr\",\n    admin:    true,\n    config:   {\n      email: \"test@test.com\",\n    },\n  },\n}\n\nPope.pope(\n  \"The user {{user.username}} with id {{user.id}} is cool\",\n  data\n) # \"The user krthr with id 123 is cool\"\n\nPope.prop(data, \"user.id\")           #  123\nPope.prop(data, \"user.config.email\") # test@test.com\nPope.prop(data, \"nananana\")          # nil\n```\n\n## Contributing\n\n1. Fork it (<https://github.com/krthr/pope.cr/fork>)\n2. Create your feature branch (`git checkout -b my-new-feature`)\n3. Commit your changes (`git commit -am 'Add some feature'`)\n4. Push to the branch (`git push origin my-new-feature`)\n5. Create a new Pull Request\n\n## Contributors\n\n- [krthr](https://github.com/krthr) - creator and maintainer\n","program":{"html_id":"/toplevel","path":"toplevel.html","kind":"module","full_name":"Top Level Namespace","name":"Top Level Namespace","abstract":false,"superclass":null,"ancestors":[],"locations":[],"repository_name":"","program":true,"enum":false,"alias":false,"aliased":"","const":false,"constants":[],"included_modules":[],"extended_modules":[],"subclasses":[],"including_types":[],"namespace":null,"doc":null,"summary":null,"class_methods":[],"constructors":[],"instance_methods":[],"macros":[],"types":[{"html_id":"/Pope","path":"Pope.html","kind":"module","full_name":"Pope","name":"Pope","abstract":false,"superclass":null,"ancestors":[],"locations":[],"repository_name":"","program":false,"enum":false,"alias":false,"aliased":"","const":false,"constants":[{"id":"VERSION","name":"VERSION","value":"\"0.1.0\"","doc":null,"summary":null}],"included_modules":[],"extended_modules":[],"subclasses":[],"including_types":[],"namespace":null,"doc":"NOTE: Pope.cr is the Crystal version of [Pope](https://github.com/poppinss/pope).\n\nA fast, minimal and micro template engine for strings only, it plays well where you want to embed micro templates inside your module.\n\n","summary":"<p><span class=\"flag purple\">NOTE</span>  Pope.cr is the Crystal version of <a href=\"https://github.com/poppinss/pope\" target=\"_blank\">Pope</a>.</p>","class_methods":[{"id":"pope(string:String,data:NamedTuple,opts={skipUndefined:false,throwOnUndefined:false})-class-method","html_id":"pope(string:String,data:NamedTuple,opts={skipUndefined:false,throwOnUndefined:false})-class-method","name":"pope","doc":"parses a given template string and replace dynamic placeholders with actual data.\n\n```\ndata = {\n  user: {\n    id:       123,\n    username: \"krthr\",\n    admin:    true,\n    config:   {\n      email: \"test@test.com\",\n    },\n  },\n}\nPope.pope(\n  \"The user {{user.username}} with id {{user.id}} is cool\",\n  data\n) # \"The user krthr with id 123 is cool\"\n```","summary":"<p>parses a given template string and replace dynamic placeholders with actual data.</p>","abstract":false,"args":[{"name":"string","doc":null,"default_value":"","external_name":"string","restriction":"String"},{"name":"data","doc":null,"default_value":"","external_name":"data","restriction":"NamedTuple"},{"name":"opts","doc":null,"default_value":"{skipUndefined: false, throwOnUndefined: false}","external_name":"opts","restriction":""}],"args_string":"(string : String, data : NamedTuple, opts = {skipUndefined: <span class=\"n\">false</span>, throwOnUndefined: <span class=\"n\">false</span>})","source_link":null,"def":{"name":"pope","args":[{"name":"string","doc":null,"default_value":"","external_name":"string","restriction":"String"},{"name":"data","doc":null,"default_value":"","external_name":"data","restriction":"NamedTuple"},{"name":"opts","doc":null,"default_value":"{skipUndefined: false, throwOnUndefined: false}","external_name":"opts","restriction":""}],"double_splat":null,"splat_index":null,"yields":null,"block_arg":null,"return_type":"","visibility":"Public","body":"string.gsub(/{{2}(.+?)}{2}/) do |str, match|\n  path = match[1]\n  val = self.prop(data, path)\n  if val == nil\n    if opts[:throwOnUndefined]\n      raise(\"Missing value for #{path}\")\n    end\n    if opts[:skipUndefined]\n      val = str\n    end\n  end\n  val\nend"}},{"id":"prop(obj:NamedTuple,path:String)-class-method","html_id":"prop(obj:NamedTuple,path:String)-class-method","name":"prop","doc":"get nested properties from a given object using dot notation\n\n```\ndata = {\n  user: {\n    id:       123,\n    username: \"krthr\",\n    admin:    true,\n    config:   {\n      email: \"test@test.com\",\n    },\n  },\n}\nPope.prop(data, \"user.id\")           #  123\nPope.prop(data, \"user.config.email\") # test@test.com\nPope.prop(data, \"nananana\")          # nil\n```","summary":"<p>get nested properties from a given object using dot notation</p>","abstract":false,"args":[{"name":"obj","doc":null,"default_value":"","external_name":"obj","restriction":"NamedTuple"},{"name":"path","doc":null,"default_value":"","external_name":"path","restriction":"String"}],"args_string":"(obj : NamedTuple, path : String)","source_link":null,"def":{"name":"prop","args":[{"name":"obj","doc":null,"default_value":"","external_name":"obj","restriction":"NamedTuple"},{"name":"path","doc":null,"default_value":"","external_name":"path","restriction":"String"}],"double_splat":null,"splat_index":null,"yields":null,"block_arg":null,"return_type":"","visibility":"Public","body":"if path != \"\"\nelse\n  raise(\"Missing path.\")\nend\nprops = path.split(\".\")\ni = 0\nwhile i < props.size && (obj != nil)\n  prop = props[i]\n  obj = obj.responds_to?(:[]?) ? obj[prop]? : nil\n  i = i + 1\nend\nobj\n"}}],"constructors":[],"instance_methods":[],"macros":[],"types":[]}]}})