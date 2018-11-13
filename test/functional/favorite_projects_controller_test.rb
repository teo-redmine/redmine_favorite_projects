require File.expand_path('../../test_helper', __FILE__)

class FavoriteProjectsControllerTest < ActionController::TestCase
  fixtures :projects,
           :users,
           :roles,
           :members,
           :member_roles,
           :issues,
           :issue_statuses,
           :versions,
           :trackers,
           :projects_trackers,
           :issue_categories,
           :enabled_modules,
           :enumerations,
           :attachments,
           :workflows,
           :custom_fields,
           :custom_values,
           :custom_fields_projects,
           :custom_fields_trackers,
           :time_entries,
           :journals,
           :journal_details

  RedmineFavoriteProjects::TestCase.create_fixtures(Redmine::Plugin.find(:redmine_favorite_projects).directory + '/test/fixtures/',
                                                    [:favorite_projects])

  def setup
    @request.session[:user_id] = 1
  end

  def test_search
    get :search
    assert_select 'tr.project', count: 6

    get :search, project_search: 'E-commerce'
    assert_select 'tr.project', count: 1
    assert_match(/E-commerce/, response.body)
  end

  def test_favorite
    assert_equal 2, FavoriteProject.where(user_id: 1).count
    get :favorite, project_id: 6
    assert_response 302
    assert_equal 3, FavoriteProject.where(user_id: 1).count
  end

  def test_unfavorite
    assert_equal 2, FavoriteProject.where(user_id: 1).count
    get :unfavorite, project_id: 2
    assert_response 302
    assert_equal 1, FavoriteProject.where(user_id: 1).count
  end
end
