class Post < ApplicationRecord
  has_many :tag_maps, dependent: :destroy
  has_many :tags, through: :tag_maps
  
  def update_and_create_tags(post_tags)
  # その投稿が持っているタグを列挙
  current_tags = self.tags.pluck(:name) unless self.tags.nil?
  # 変更があった場合に削除されるアソシエーションを列挙
  # 配列同士で減算できる！すごい！！！
  old_tags = current_tags - post_tags
  # 今回保存されたものと現在の差を新しいタグとする。新しいタグは保存
  new_tags = post_tags - current_tags

    # Destroy old taggings:
    old_tags.each do |old_name|
      self.tags.delete Tag.find_by(name:old_name)
    end

    # Create new taggings:
    new_tags.each do |new_name|
      post_tag = Tag.find_or_create_by(name:new_name)
      # 配列に保存
      self.tags << post_tag
    end
  end
end
