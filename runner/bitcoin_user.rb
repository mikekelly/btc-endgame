class BitcoinUser
  def initialize(name:,node_url:,session_wallet_name: nil)
    @name = name
    @node_url = node_url
    @session_wallet_name = session_wallet_name
  end

  def balance
    raise "No session wallet available named #{session_wallet_name}" if session_wallet.nil?
    session_wallet.balance
  end

  def send_to(user:, amount:, fee_rate: 1)
    session_wallet.request('sendtoaddress', user.address, amount, "", "", false, true, nil, "unset", false, fee_rate)
  end

  def address
    @address ||= session_wallet.request('getnewaddress')
  end

  def session_wallet
    if @session_wallet_name.nil?
      @session_wallet_name = SecureRandom.uuid
      client.request('createwallet', @session_wallet_name)
    end
    @session_wallet ||= client.wallet_named(@session_wallet_name)
  end

  private

  def client
    @client ||= Bitcoiner.new(rpc_username, rpc_password, node_url)
  end

  def rpc_username
    "satoshi"
  end

  def rpc_password
    "waswrong"
  end

  attr_reader :name, :node_url, :session_wallet_name
end

