require 'sinatra'
require 'sinatra/json'

class ForMakeBenefitGloriousLeaderAdamBack < Sinatra::Base
  set :bad_block_list, []
  set :bind, '0.0.0.0'

  get '/' do
    erb :ministry_of_chain_truth
  end

  post '/blocks' do
    bad_block_list.push(params[:block_hash])
    redirect '/'
  end

  get '/blocks' do
    json({ banned_blocks: bad_block_list })
  end

  private

  def bad_block_list
    self.class.bad_block_list
  end

  run! if app_file == $0
end
