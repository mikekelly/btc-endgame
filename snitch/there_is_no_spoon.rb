require 'sinatra'
require 'sinatra/json'
require 'tty-tree'
require_relative 'blorkchain'

class ThereIsNoSpoon < Sinatra::Base
  set :bad_block_list, []
  set :bind, '0.0.0.0'

  get '/' do
    blorkchain = Blorkchain.new
    raw_block_trees = blorkchain.branches_at_depth(51).map(&:to_h)
    @block_trees = raw_block_trees.map { |raw_block_tree| TTY::Tree.new(raw_block_tree) }
    @orphaned_blocks = blorkchain.orphaned_blocks
    @mempool_count = blorkchain.mempool_count
    erb :rubber_dinghy_rapids_bro
  end

  private

  run! if app_file == $0
end
