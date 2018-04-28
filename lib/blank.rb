# Blatantly stealing the following utility methods from the Rails API.
class Object
  def blank?
    respond_to?(:empty?) ? !!empty? : !self
  end

  def present?
    !blank?
  end
end

