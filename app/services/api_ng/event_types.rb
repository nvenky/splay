module ApiNg
  class EventTypes < ApiNg::JsonRpc
    include ApiNg::SportsURI

    def method_name
      'listEventTypes'
    end

    def default_params
      {'filter' => {}}
    end
  end
end
