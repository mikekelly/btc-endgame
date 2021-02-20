require 'securerandom'
require 'bitcoiner'
require 'pry'
require_relative './bitcoin_user'

red_node_url = ENV.fetch("RED_NODE_URL")
blue_node_url = ENV.fetch("BLUE_NODE_URL")
jack_node_url = ENV.fetch("JACK_NODE_URL")
jill_node_url = ENV.fetch("JILL_NODE_URL")

red_team = BitcoinUser.new(name: 'red_team', node_url: red_node_url, session_wallet_name: 'redwallet')
blue_team = BitcoinUser.new(name: 'blue_team', node_url: blue_node_url, session_wallet_name: 'bluewallet')
jack = BitcoinUser.new(name: 'jack', node_url: jack_node_url)
jill = BitcoinUser.new(name: 'jill', node_url: jack_node_url)

puts "Jack's address for this session: #{jack.address}"
puts "Jill's address for this session: #{jill.address}"

puts "Waiting for blue team to have funds for Jack and Jill..."
loop do
  break if blue_team.balance > 0
  puts "Rechecking blue team balance in 30s..."
  sleep 30
end

puts

blue_team_balance = blue_team.balance - 2 # hold 2 BTC back to cover fees
amount_to_remit = (blue_team_balance/2).round(8)

puts "Remitting #{amount_to_remit} to Jack..."
blue_team.send_to(user: jack, amount: amount_to_remit)
puts "Done."
puts "Remitting #{amount_to_remit} to Jill..."
blue_team.send_to(user: jill, amount: amount_to_remit)
puts "Done"

puts

puts "Waiting for Jack and Jill's funds to get confirmed..."
loop do
  break if jack.balance > 0 && jill.balance > 0
  puts "Rechecking their balances in 30s..."
  sleep 30
end

puts

amount_to_exchange = (amount_to_remit/100_000).round(8)

puts "Jack and Jill begin happily exchanging bitcoin with each other..."
loop do
  puts

  puts "Jack sending #{amount_to_exchange} to Jill..."
  jack.send_to(user: jill, amount: amount_to_exchange)
  puts "Done."

  puts "Jill sending #{amount_to_exchange} to Jack..."
  jill.send_to(user: jack, amount: amount_to_exchange)
  puts "Done."

  puts "They both wait 10 seconds..."
  sleep 10
end
