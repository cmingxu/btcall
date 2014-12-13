# -*- encoding : utf-8 -*-
# == Schema Information
#
# Table name: pages
#
#  id         :integer          not null, primary key
#  slug       :string(255)
#  content    :text
#  created_at :datetime
#  updated_at :datetime
#

class Page < ActiveRecord::Base
  validates_presence_of :title, :slug
  validates_uniqueness_of :title, :slug

  scope :publisheds,:conditions => {:publish => true}
end
