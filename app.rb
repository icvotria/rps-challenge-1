require 'sinatra/base'
require 'sinatra/reloader'
require_relative './lib/player'
require_relative './lib/game'

class RPSGame < Sinatra::Base
  enable :sessions

  configure :development do
    register Sinatra::Reloader
  end

  get '/' do
    erb :index
  end

  post '/names' do
    # I promise to never use global variables in tech tests
    player = Player.new(params[:player_1_name].capitalize)
    $game = Game.new(player.name)
  
    redirect '/play'
  end

  get '/play' do
    @game = $game
    
    erb :play
  end

  post '/movechoice' do
    session[:move] = params[:move]

    redirect '/move'
  end

  get '/move' do
    @move = session[:move]
    session[:computer_move] = $game.computer_move
    @computer_move = session[:computer_move]
    p session
    erb :move
  end

  run! if app_file == $0
end
