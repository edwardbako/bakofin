class Quote < ApplicationRecord
  ActiveModel::Model
  belongs_to :symb

  scope :m1, -> { where(timeframe: 1) }
  scope :m5, -> { where(timeframe: 5) }
  scope :m15, -> { where(timeframe: 15) }
  scope :m30, -> { where(timeframe: 30) }
  scope :h1, -> { where(timeframe: 60) }
  scope :h4, -> { where(timeframe: 240) }
  scope :d1, -> { where(timeframe: 1440) }

  def x
    time.to_i * 1000
  end

  def y
    volume
  end

  def name
    time.to_formatted_s
  end

end
