# frozen_string_literal: true

FactoryBot.define do
  factory :order do
    start = Time.current - 2.years
    stop = Time.current - 1.year

    symbol { "XAUUSD" }
    open_date { Faker::Time.between(from: start, to: stop) }
    lot_size { 1 }
    open_price { 100 }
    close_price { 200 }
    stop_loss { nil }
    take_profit { nil }
    comment { "Comment" }
    magic_number { "MyString" }
    profit { 1 }
    swap { 0 }
    commission { 0.05 }
    account
    test { true }

    trait :buy do
      kind { :buy }
    end

    trait :sell do
      kind { :sell }
    end

    trait :balance do
      kind { :balance }
    end

    trait :closed do
      sequence(:close_date) { |n| stop + n.weeks }
    end

    factory :balance_order, traits: %i[balance closed] do
      close_price { 100_000 }
      close_date { start }
    end

    factory :opened_buy_order, traits: [ :buy ]
    factory :closed_buy_order, traits: %i[buy closed]
    factory :opened_sell_order, traits: [ :sell ]
    factory :closed_sell_order, traits: %i[sell closed]
  end
end
