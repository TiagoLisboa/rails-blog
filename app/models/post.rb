class Post
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, type: String
  field :abstract, type: String
  field :content, type: String
  field :tags, type: Array, default: []

  belongs_to :user

  mount_uploader :thumbnail, AvatarUploader

  def self.all_tags()
    Post.all.count > 0? Post.all.map { |post| post.tags }.reduce(:concat).to_set : []
  end

end
