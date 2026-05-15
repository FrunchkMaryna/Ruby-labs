class Course < ApplicationRecord
    enum :status, { draft: 0, active: 1, archived: 2 }

    validates :title, presence: true
end
