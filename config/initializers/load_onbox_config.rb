raw_config = File.read(RAILS_ROOT + "/config/onbox_config.yml")
all_values = YAML.load(raw_config)
# First collect all single level config values then replace with env specific values
env_values = all_values[RAILS_ENV]
base_values = all_values.delete_if{|k, v| v.instance_of?(Hash)}
ONBOX_CONFIG = base_values.merge(env_values).symbolize_keys
