class ApiException < StandardError
  attr_reader :code, :message, :detail

  ERROR_CODE_MAP = I18n.t("error_messages").freeze

  def initialize(exception_type)
    error = ERROR_CODE_MAP[exception_type.to_sym]
    @code = error[:code]
    @message = error[:message]
    @detail = error[:detail]
    super(detail)
  end
end
