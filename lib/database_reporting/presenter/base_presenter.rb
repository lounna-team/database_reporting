module DatabaseReporting
  # Presenter module
  module Presenter
    require 'colorize'
    # Base class presenter
    class BasePresenter
      private

      def text_red(value)
        value.to_s.colorize(:red)
      end

      def text_yellow(value)
        value.to_s.colorize(:yellow)
      end

      def text_light_blue(value)
        value.to_s.colorize(:light_blue)
      end

      def text_green(value)
        value.to_s.colorize(:green)
      end
    end
  end
end
