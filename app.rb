require "sinatra"
require "sinatra/activerecord"
require "sinatra/namespace"
require "./config/environments"
require "./models/event"
require "./serializers/event_serializer"

# get ALL events
get "/" do
  @events = Event.all
  erb :index
end

# URL with form for new post
get "/events/new" do
  erb :new
end

# create
post "/create" do
  @event = Event.new(params[:event])
  if @event.save
    # json @event
    redirect "/"
  else
    "Sorry, there was an error!"
  end
end

# edit
get "/events/:id/edit" do
  @event = Event.find(params[:id])
  erb :edit
end

# update
put "/events/:id" do
  @event = Event.find(params[:id])
  @event.update(params[:event])
  redirect "/events/#{@event.id}"
end

# show
get "/events/:id" do
  @event = Event.find(params[:id])
  erb :show
end

# delete
delete "/events/:id/delete" do
  @event = Event.find(params[:id])
  @event.delete
  redirect "/"
end

namespace "/api/v1" do
  before do
    content_type :json
  end

  helpers do
    def base_url
      @base_url ||= "#{request.env['rack.url_scheme']}://{request.env['HTTP_HOST']}"
    end

    def json_params
      begin
        JSON.parse(request.body.read)
      rescue
        halt 400, { message: "Invalid JSON" }.to_json
      end
    end

    def event
      @event = Event.where(id: params[:id]).first
    end

    def halt_if_not_found!
      halt(404, { message: "Event not found" }.to_json) unless event
    end
  end

  get "/events" do
    events = Event.all
    events.map{ |event| EventSerializer.new(event) }.to_json
    # Event.all.to_json
  end

  get "/events/:id" do |id|
    halt_if_not_found!
    EventSerializer.new(event).to_json
  end

  post "/events" do
    event = Event.new(json_params)
    if event.save
      response.headers['Location'] = "#{base_url}/api/v1/events/{event.id}"
      status 201
    else
      status 422
      body EventSerializer.new(event).to_json
    end
  end

  patch "/events/:id" do |id|
    halt_if_not_found!
    if event.update_attributes(json_params)
      EventSerializer.new(event).to_json
    else
      status 422
      body EventSerializer.new(event).to_json
    end
  end

  delete "/events/:id" do |id|
    event.destroy if event
    status 204
  end
end
