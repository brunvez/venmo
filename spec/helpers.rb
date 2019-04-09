module Helpers
  def json(response)
    JSON.parse(response.body).with_indifferent_access
  end
end
