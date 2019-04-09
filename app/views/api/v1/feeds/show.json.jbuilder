json.feed do
  json.payments @payments do |payment|
    json.id payment.id
    json.title payment.title
    json.description payment.description
    json.amount payment.amount
  end
end

