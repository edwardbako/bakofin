class Quote < ApplicationRecord
  belongs_to :symb

  def x
    time.to_i * 1000
  end

  alias_method :y, :volume

  def name
    time.to_formatted_s
  end

end
