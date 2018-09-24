require "sinatra"
require "sinatra/activerecord"
require "sinatra/json"
require "./config/environments"
require "./models/event"

mime_type :json, "application/json"

# before do
#   content_type :json
# end

helpers do
  def json(dataset)
    if !dataset
      return no_data
    else
      JSON.pretty_generate(JSON.load(dataset.to_json)) + "\n"
    end
  end

  def no_data!
    status 204
  end
end

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
