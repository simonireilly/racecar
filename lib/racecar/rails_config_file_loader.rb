module Racecar
  module RailsConfigFileLoader
    def self.load!
      config_file = "config/racecar.yml"

      begin
        require "rails"

        if defined?(Rails)
          $stderr.puts "=> Detected Rails, booting application..."

          require "./config/environment"

          if (Rails.root + config_file).readable?
            Racecar.config.load_file(config_file, Rails.env)
          end

          # In development, write Rails logs to STDOUT. This mirrors what e.g.
          # Unicorn does.
          if Rails.env.development? && defined?(ActiveSupport::Logger)
            console = ActiveSupport::Logger.new($stdout)
            console.formatter = Rails.logger.formatter
            console.level = Rails.logger.level
            Rails.logger.extend(ActiveSupport::Logger.broadcast(console))
          end
        end
      rescue LoadError
        # Not a Rails application.
      end
    end
  end
end
