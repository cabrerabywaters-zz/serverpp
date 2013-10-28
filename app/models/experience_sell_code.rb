class ExperienceSellCode < ExperienceCode
  def generate_code
    begin
      code = sprintf '%09d', SecureRandom.random_number(999_999_999)
    end while ExperienceCode.exists?(code: code)
    code
  end
end