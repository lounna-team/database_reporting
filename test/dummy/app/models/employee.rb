class Employee < ApplicationRecord
  enum gender: { woman: 0, man: 1, not_defined: 2 }, _prefix: true
  enum college_type: { not_defined: 0, cadre: 1, no_cadre: 2 }, _prefix: true
end
