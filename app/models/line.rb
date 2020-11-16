class Line < Array
  include ActiveModel::Model
  include ActiveModel::Serializers::JSON

  attr_accessor :digits
end