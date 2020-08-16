module Interface

  class Base

    include Actions::Base

    attr_reader :selected_action, :action_data

    def initialize
      @prompt = $prompt
    end

    def keypress
      @prompt.keypress("Press space or enter to continue", keys: [:space, :return])
    end

    def fetch_data(action)
      raise NotImplementedError
    end

    def display_data(data)
      table = TTY::Table.new(data)
      renderer = TTY::Table::Renderer::ASCII.new(table)
      puts renderer.render
    end

    def mode
      @prompt.select('Select your mode : ', SUPPORTED_MODES)
    end

  end
end
