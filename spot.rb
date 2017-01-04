#!/usr/bin/env ruby

require 'aws-sdk'
require 'deep_merge'

def get_client
  Aws::EC2::Client.new({
      region: 'eu-west-1'
  })
end

#extra_params a hash that will be merged with the default params
def request_spot(client, extra_params)
  default_params = {
    :launch_specification => {
      :image_id => 'ami-2a0c2a59',
      :instance_type => 'g2.2xlarge',
      :key_name => 'bandanatech'
    }
  }
  params = extra_params.deep_merge(default_params)
  p params
  client.request_spot_instances(params)
end

client = get_client
#response = request_spot client, {
#  :spot_price => '0.10' 
#}
#puts response

puts client
puts client.describe_reserved_instances_offerings
