# encoding: utf-8

require_dependency 'application_helper'

module RedmineFavoriteProjects
  module Patches
    module ApplicationHelperPatch
      def self.included(base)
        base.class_eval do
          def render_project_jump_box
            return unless User.current.logged?
            favorite_projects = favorite_list
            return if favorite_projects.nil? || !favorite_projects.any?

            options = "<option value=''>#{l(:label_jump_to_a_project)}</option>" \
                      '<option value="" disabled="disabled">---</option>'.html_safe

            options << project_tree_options_for_select(favorite_projects, selected: @project) do |p|
              { value: project_path(id: p, jump: current_menu_item) }
            end

            content_tag(:span, nil, class: 'jump-box-arrow') +
              select_tag('project_quick_jump_box', options, onchange: 'if (this.value != \'\') { window.location = this.value; }')
          end

          def project_tree_options_for_select(projects, options = {})
            s = ''.html_safe
            unless options[:include_blank].blank?
              blank_text = '&nbsp;'.html_safe
              s << content_tag('option', blank_text, value: '')
            end

            project_tree(projects) do |project, level|
              name_prefix = (level > 0 ? '&nbsp;' * 2 * level + '&#187; ' : '').html_safe
              tag_options = { value: project.id }
              if project == options[:selected] || (options[:selected].respond_to?(:include?) && options[:selected].include?(project))
                tag_options[:selected] = 'selected'
              else
                tag_options[:selected] = nil
              end
              tag_options.merge!(yield(project)) if block_given?
              s << content_tag('option', name_prefix + project_name(project, true), tag_options)
            end
            s.html_safe
          end
        end
      end
    end
  end
end

unless ApplicationHelper.included_modules.include?(RedmineFavoriteProjects::Patches::ApplicationHelperPatch)
  ApplicationHelper.send(:include, RedmineFavoriteProjects::Patches::ApplicationHelperPatch)
end
