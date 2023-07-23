class Province < ApplicationRecord
    has_many :users

    def self.ransackable_attributes(auth_object = nil)
        super + %w[name other_attribute] 
    end
end
