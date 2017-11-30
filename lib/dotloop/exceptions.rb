# frozen_string_literal: true

module Dotloop
  class BadRequest < StandardError; end
  class Forbidden < StandardError; end
  class NotFound < StandardError; end
  class TooManyRequest < StandardError; end
  class Unauthorized < StandardError; end
  class UnprocessableEntity < StandardError; end
end
