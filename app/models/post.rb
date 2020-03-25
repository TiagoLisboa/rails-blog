class Post
  include Mongoid::Document
  include Mongoid::Timestamps
  field :title, type: String
  field :abstract, type: String
  field :content, type: String
end
