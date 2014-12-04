# -*- encoding : utf-8 -*-
class Page < ActiveRecord::Base
  attr_accessible :title, :slug, :genre, :sort, :content, :publish
  validates_presence_of :title, :slug
  validates_uniqueness_of :title, :slug

  scope :publisheds,:conditions => {:publish => true}
end
