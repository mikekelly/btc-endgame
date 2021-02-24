require 'ostruct'
require 'bitcoiner'
require 'pry'

class Blorkchain
  def initialize(blocks:Hash.new, blocks_by_height:Hash.new, orphaned_blocks:Array.new)
    @blocks = blocks
    @blocks_by_height = blocks_by_height
    @orphaned_blocks = orphaned_blocks
  end

  def to_h
    build_block_tree!
    genesis_block.to_h
  end

  def branches_at_depth(depth)
    build_block_tree!
    blocks_by_height[depth].to_a
  end

  def mempool_count
    client.request('getmempoolinfo')["size"]
  end

  attr_reader :orphaned_blocks

  private

  def build_block_tree!
    chain_tip_hashes.each do |block_hash|
      walk_to_genesis(block_hash)
    end
  end

  def chain_tip_hashes
    client.request('getchaintips').map do |chain_tip|
      chain_tip.fetch("hash")
    end
  end

  def walk_to_genesis(hash)
    blocks[hash] ||= fetch_block(hash)
  end

  def fetch_block(hash)
    fetched_block = client.request("getblock", hash) rescue nil
    return if fetched_block.nil?
    Block.new(fetched_block).tap { |block|
      (blocks_by_height[block.height] ||= Array.new).push(block)
      orphaned_blocks.push(block) if block.confirmations < 0
      if block.previousblockhash
        block.attach_to_parent(walk_to_genesis(block.previousblockhash))
      else
        @genesis_block = block
      end
    }
  end

  def client
    @client ||= Bitcoiner.new(rpc_username, rpc_password, node_url)
  end

  def rpc_username
    "satoshi"
  end

  def rpc_password
    "waswrong"
  end

  def node_url
    "http://blue-node:8332"
  end

  attr_reader :blocks, :blocks_by_height, :genesis_block

  class Block < OpenStruct
    def attach_to_parent(block)
      block.children_as_hash ||= Hash.new
      block.children_as_hash[self.hash] = self
    end

    def children
      children_as_hash.to_h.values
    end

    def to_h
      object = {}
      description = hash + " :: #{nTx.to_i} txns"
      if nTx.to_i < 2
        description << " (EMPTY BLOCK!)"
      end
      description << " :: height=#{height}"
      object[description] = children.map(&:to_h)
      object
    end
  end
end
