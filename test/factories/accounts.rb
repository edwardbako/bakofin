# frozen_string_literal: true

FactoryBot.define do
  factory :account do
    login { "Test Account" }
    password { "Password" }
    currency { "USD" }
    leverage { 1 }

    factory :account_with_orders do
      transient do
        sequence(:orders_count) { |n| n }
      end

      after(:create) do |account|
        # create_list(:balance_order, 1, account: account)

        %i[
          balance_order
          opened_buy_order
          closed_buy_order
          opened_sell_order
          closed_sell_order
        ].each_with_index do |kind, i|
          create_list(kind, (i + 1), account:)
        end
        # account.reload
      end
    end
  end
end
