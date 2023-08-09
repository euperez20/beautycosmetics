class Product < ApplicationRecord
  belongs_to :category
  has_many :product_colors
  has_many :colors, through: :product_colors

  has_one_attached :image

  
  
  def self.ransackable_attributes(auth_object = nil)
    ["brand", "category_id", "created_at", "description", "id", "image", "name", "price", "updated_at"]
  end
  
  def self.ransackable_associations(auth_object = nil)
    ["category", "colors", "product_colors"]
  end

  # Image
  def validate_image
    if image.attached?
      unless image.content_type.in?(%w[image/png image/jpg image/jpeg image/gif])
        errors.add(:image, 'must be a valid image format (PNG, JPG, JPEG, GIF)')
      end
      unless image.byte_size < 5.megabytes
        errors.add(:image, 'size should be less than 5MB')
      end
    elsif image_url.present?
      # Custom validation for image_url, e.g., URL format validation
    else
      errors.add(:image, 'must be attached or a valid URL')
    end
  end




end
