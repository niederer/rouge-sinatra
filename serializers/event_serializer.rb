class EventSerializer
  def initialize(event)
    @event = event
  end

  def as_json(*)
    data = {
      id: @event.id.to_s,
      title: @event.title,
      start_date: @event.start_date
    }
    data[:errors] = @event.errors if @event.errors.any?
    data
  end
end
