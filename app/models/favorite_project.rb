# encoding: utf-8
#

class FavoriteProject < ActiveRecord::Base
  def self.favorite?(project_id, user_id = User.current.id)
    FavoriteProject.find_by_project_id_and_user_id(project_id, user_id).nil?
  end
end
