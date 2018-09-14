require 'sinatra'
require 'sinatra/activerecord'
require './config/environments'
require './models/event'

get '/' do
  erb :index
end

post '/submit' do
  @event = Event.new(params[:event])
  if @event.save
    redirect '/events'
  else
    "Sorry, there was an error!"
  end
end

get '/events' do
  @events = Event.all
  erb :events
end
