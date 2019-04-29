local typedefs = require "kong.db.schema.typedefs"


return {
  name = "demoauth",
  fields = {
    { consumer = typedefs.no_consumer },
    { run_on = typedefs.run_on_first },
    { config = {
        type = "record",
        fields = {
          { key_names = {
              type = "array",
              required = true,
              elements = typedefs.header_name,
              default = { "authkey" },
          }, },
        },
    }, },
  },
}
