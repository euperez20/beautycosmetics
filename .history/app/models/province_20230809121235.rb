class Province < ApplicationRecord
  has_many :users
  has_many :orders    
  
  validates :name, presence: true, uniqueness: true
  validates :gst_rate, numericality: { greater_than_or_equal_to: 0 }
  validates :pst_rate, numericality: { greater_than_or_equal_to: 0 }
  validates :hst_rate, numericality: { greater_than_or_equal_to: 0 }
  

  def self.ransackable_attributes(auth_object = nil)
    super + %w[name other_attribute orders_id_eq]
  end

  def self.ransackable_associations(auth_object = nil)
    ["users"] 
  end

  def hst_applicable
  
        hst_rate > 0
      end
end
