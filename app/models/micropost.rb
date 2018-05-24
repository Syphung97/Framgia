class Micropost < ApplicationRecord
  belongs_to :user
  validates :user, presence: true
  validates :content, presence: true,
    length: {maximum: Settings.micropost.content.max_length}
  validate :picture_size

  scope :desc, ->{order created_at: :desc}
  mount_uploader :picture, PictureUploader

  private

  def picture_size
    max_size = Settings.img_size
    errors.add :picture, t("size_img") if picture.size > max_size.megabytes
  end
end
