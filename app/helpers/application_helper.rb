module ApplicationHelper
  def lower_cased_class(object)
    object.class.to_s.downcase
  end
end
