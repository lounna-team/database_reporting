module DatabaseReporting
  # Presenter module
  module Presenter
    require 'colorize'
    # Base class presenter
    class BasePresenter
      private

      def text_red(value:)
        value.colorize(:red)
      end

      def text_yellow(value:)
        value.colorize(:yellow)
      end

      def text_green(value:)
        value.colorize(:green)
      end
    end
  end
end
