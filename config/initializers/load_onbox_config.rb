raw_config = File.read(RAILS_ROOT + "/config/onbox_config.yml")
ONBOX_CONFIG = YAML.load(raw_config)[RAILS_ENV].symbolize_keys
