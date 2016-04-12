class OrderSerializer < ActiveModel::Serializer
  attributes :id, :total, :product_ids
end
