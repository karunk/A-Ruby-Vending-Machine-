require 'active_record'

connection_info = YAML.load_file("db/config.yml")["test"]
ActiveRecord::Base.establish_connection(connection_info)

