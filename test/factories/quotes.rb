FactoryBot.define do
  factory :quote do
    time { Time.new("2024-10-04 19:00:00 +0300") }
    open { 2653.49 }
    high { 2653.7 }
    low { 2647.92 }
    close { 2648.8 }
    volume { 8151 }
  end
end
