class EmailValidator < ActiveModel::EachValidator
  REGEX_PATTERN = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i.freeze

  def validate_each(record, attribute, value)
    return if value.blank?

    resp = (REGEX_PATTERN =~ value).present?

    record.errors[attribute] << (options[:message] || "is not an email") unless resp
  end
end
