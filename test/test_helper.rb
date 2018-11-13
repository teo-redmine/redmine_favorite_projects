# Load the Redmine helper
require File.expand_path(File.dirname(__FILE__) + '/../../../test/test_helper')

module RedmineFavoriteProjects
  class TestCase
    def self.create_fixtures(fixtures_directory, table_names, _class_names = {})
      ActiveRecord::FixtureSet.create_fixtures(fixtures_directory, table_names, _class_names = {})
    end
  end
end
