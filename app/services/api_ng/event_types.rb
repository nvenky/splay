module ApiNg
  class EventTypes < ServiceBase

    def method_name
      'listEventTypes'
    end

    def default_params
      {'filter' => {}}
    end
  end
end
