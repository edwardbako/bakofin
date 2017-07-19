{ en: { i18n: { plural: { keys: [:zero, :one, :few, :many],
                          rule: lambda { |n|
                            case
                              when n == 0
                                :zero
                              when ((n % 10) == 1) && ((n % 100 != 11))
                                # 1, 21, 31, 41, 51, 61...
                                :one
                              # when [2, 3, 4].include?(n % 10) && ![12, 13, 14].include?(n % 100)
                              #   # 2-4, 22-24, 32-34...
                              #   :few
                              else
                                :other
                            end
                          }
}}},
 ru: { i18n: { plural: { keys: [:zero, :one, :few, :many],
                          rule: lambda { |n|
                            case
                              when n == 0
                                :zero
                              when ((n % 10) == 1) && ((n % 100 != 11))
                                # 1, 21, 31, 41, 51, 61...
                                :one
                              when [2, 3, 4].include?(n % 10) && ![12, 13, 14].include?(n % 100)
                              #   # 2-4, 22-24, 32-34...
                                :few
                              else
                                :other
                            end
                          }
}}}}