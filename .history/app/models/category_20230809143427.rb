class Category < ApplicationRecord
    has_many :products
    

    validates :name, presence: true, uniqueness: true
    validates :created_at, presence: true
    validates :updated_at, presence: true
    
    def self.ransackable_attributes(auth_object = nil)
        ["created_at", "id", "name", "updated_at"]
    end
    
    def self.ransackable_associations(auth_object = nil)
        ["products"]
    end


end
