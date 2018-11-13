# encoding: utf-8
#

module RedmineFavoriteProjects
  module Helper
    def project_name(project, only_text = false, html_options = {})
      project_name_view = if project.project_name_view.blank? || project.project_name_view == '0'
                            Setting.plugin_redmine_favorite_projects['project_name_view']
                          else
                            project.project_name_view
                          end

      name = case project_name_view
             when '2' then project.identifier
             when '3' then project.identifier + ': ' + project.name
             when '4' then project.name + ': ' + project.identifier
             else project.name
             end

      if project.active? && !only_text
        if Setting.plugin_redmine_favorite_projects['show_project_desc'].to_s.blank?
          link_to(name, project_path(project), { title: project.short_description }.merge(html_options))
        else
          link_to(name, project_path(project), html_options)
        end
      else
        h(name)
      end
    end

    def favorite_css_classes(project, has_children)
      s = project.css_classes
      s = s.sub('parent', 'leaf') unless has_children
      s
    end

    def roles_for_select(selected = nil)
      options = []
      @roles = Role.givable.all
      @roles.each do |role|
        options << role.name
      end
      options_for_select(options, selected: selected)
    end

    def project_name_for_select(selected = nil, with_system_default = false)
      options = {}

      options[l(:project_name_view_default)] = '0' if with_system_default
      options[l(:project_name_view_name)] = '1'
      options[l(:project_name_view_id)] = '2'
      options[l(:project_name_view_id_name)] = '3'
      options[l(:project_name_view_name_id)] = '4'

      options_for_select(options, selected: selected)
    end

    def favorite_list
      return unless User.current.logged?
      favorite_projects = FavoriteProject.where(user_id: User.current.id)
      favorite_projects_ids = favorite_projects.map(&:project_id)
      User.current.memberships.collect(&:project).compact.uniq.select { |p| check_favorite_id(favorite_projects_ids, p.id) && p.active? }
    end

    def check_favorite_id(project_ids, project_id)
      if Setting.plugin_redmine_favorite_projects['default_favorite_behavior'].to_s.empty?
        project_ids.include?(project_id)
      else
        !project_ids.include?(project_id)
      end
    end
  end
end

ActionView::Base.send :include, RedmineFavoriteProjects::Helper
