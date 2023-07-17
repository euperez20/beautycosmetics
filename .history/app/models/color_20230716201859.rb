class Color < ApplicationRecord
    def self.ransackable_attributes(auth_object = nil)
        ["color_name", "created_at", "hex_value", "id", "updated_at"]
    end
end
