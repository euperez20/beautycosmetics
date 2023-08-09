class Category < ApplicationRecord
    has_many :products
    paginates_per 10
    
    def self.ransackable_attributes(auth_object = nil)
        ["created_at", "id", "name", "updated_at"]
    end
    
    def self.ransackable_associations(auth_object = nil)
        ["products"]
    end


end
