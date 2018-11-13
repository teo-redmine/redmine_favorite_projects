# encoding: utf-8
#

require 'redmine_favorite_projects/patches/application_helper_patch.rb'

Rails.configuration.to_prepare do
  if Redmine::Plugin.installed?('redmine_reporting')
    raise "\n\033[31mredmine_favorite_projects plugin cannot be used with redmine_reporting plugin'.\033[0m"
  end

  require_dependency 'redmine_favorite_projects/helpers/favorite_projects_helper'
  require_dependency 'redmine_favorite_projects/patches/projects_controller_patch.rb'
  require_dependency 'redmine_favorite_projects/patches/project_patch.rb'
  require_dependency 'redmine_favorite_projects/patches/projects_helper_patch.rb'
  require_dependency 'redmine_favorite_projects/patches/setting_patch.rb'

  require_dependency 'redmine_favorite_projects/hooks.rb'
end
