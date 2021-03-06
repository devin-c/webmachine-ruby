require 'webmachine/translation'
require 'webmachine/version'

module Webmachine
  extend Translation

  # Renders a standard error message body for the response. The
  # standard messages are defined in localization files.
  # @param [Fixnum] code the response status code
  # @param [Request] req the request object
  # @param [Response] req the response object
  # @param [Hash] options keys to override the defaults when rendering
  #     the response body
  def self.render_error(code, req, res, options={})
    res.code = code
    unless res.body
      title, message = t(["errors.#{code}.title", "errors.#{code}.message"],
                         { :method => req.method,
                           :error => res.error}.merge(options))
      res.body = t("errors.standard_body",
                   {:title => title,
                     :message => message,
                     :version => Webmachine::SERVER_STRING}.merge(options))
      res.headers['Content-Type'] = "text/html"
    end
  end

  # Superclass of all errors generated by Webmachine.
  class Error < ::StandardError; end

  # Raised when the resource violates specific constraints on its API.
  class InvalidResource < Error; end

  # Raised when the client has submitted an invalid request, e.g. in
  # the case where a request header is improperly formed. Raising this
  # exception will result in a 400 response.
  class MalformedRequest < Error; end
end # module Webmachine
