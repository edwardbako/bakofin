FactoryBot.define do
  factory :trader do
    series
    account factory: :account_with_balance, strategy: :create
    test { true }
  end
end
