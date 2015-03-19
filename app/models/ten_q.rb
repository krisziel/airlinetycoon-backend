class TenQ < ActiveRecord::Base
  belongs_to :airline
  has_one :balance_sheet
  has_one :income_statement
end
