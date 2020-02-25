module ParameterValidation

  def self.valid_url!(url)
    blank!(url)
    valid_uri!(url)
  end

  class Error < StandardError
    def initialize(msg="URL is invalid.", exception_type="custom")
      @exception_type = exception_type
      super(msg)
    end
  end

  def self.valid_uri!(url)
    uri = URI.parse(url)
    if !uri.is_a?(URI::HTTP) || uri.host.nil?
      raise Error.new 'URL is malformed.'
    end
  end

  def self.blank!(str)
    if str.nil? || str.empty?
      raise Error.new 'Requires URL parameter.'
    end
  end
end
