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

  get "/events" do
    events = Event.all
    events.map{ |event| EventSerializer.new(event) }.to_json
    # Event.all.to_json
  end
end
