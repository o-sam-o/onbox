require 'test_helper'

class GenreTest < ActiveSupport::TestCase
  should_validate_presence_of :name
end
