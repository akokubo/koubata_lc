class Payment < ActiveRecord::Base
  belongs_to :from
  belongs_to :to
end
