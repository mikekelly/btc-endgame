require 'securerandom'
require 'bitcoiner'
require 'pry'

red_node_url = ENV.fetch("RED_NODE_URL")
min_block_height = Integer(ENV.fetch("MIN_BLOCK_HEIGHT"))

client = Bitcoiner.new('satoshi', 'waswrong', red_node_url)

puts "Keeping an eye on the chain tip to kill off any honest blocks..."
loop do
  blockchain_info = client.request('getblockchaininfo')
  chain_tip_hash = blockchain_info.fetch("bestblockhash")
  block = client.request("getblock", chain_tip_hash)
  if block.fetch("nTx") > 1 && block.fetch("height") > min_block_height
    puts "Honest block with transactions detected on chain tip with hash #{chain_tip_hash}"
    client.request("invalidateblock", chain_tip_hash)
    puts "Invalidated."
  end
  sleep 1
end
