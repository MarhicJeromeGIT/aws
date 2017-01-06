#!/usr/bin/env ruby

require 'aws-sdk'
require 'deep_merge'


def get_client
  Aws::EC2::Client.new({
      region: 'eu-west-1'
  })
end

def request_ondemand(client, extra_params)
  resource = Aws::EC2::Resource.new(client: client)
  default_params = {
    dry_run: true,
    image_id: 'ami-89fed0fa',
    min_count: 1,
    max_count: 1,
    key_name: 'bandanatech',
    security_group_ids: ['sg-457e0023'],
    instance_type: 'g2.2xlarge'
  }
  params = extra_params.deep_merge(default_params)
  resource.create_instances(params)
end

#extra_params a hash that will be merged with the default params
def request_spot(client, extra_params)
  default_params = {
    :launch_specification => {
      :image_id => 'ami-2a0c2a59',
      :instance_type => 'g2.2xlarge',
      :key_name => 'bandanatech',
      :security_groups => ['gaming']
    }
  }
  params = extra_params.deep_merge(default_params)
  p params
  client.request_spot_instances(params)
end

client = get_client
response = request_spot client, {
  :spot_price => '0.8',
 :launch_specification => {
    :image_id => 'ami-bc725bcf' # Windows Gaming Working
  } 
}
puts response

#puts client
#pAuts client.describe_reserved_instances_offerings

#instance = request_ondemand(client, {})
#puts instance

# Wait for the instance to be created, running, and passed status checks
#client.wait_until(:instance_status_ok, {instance_ids: [instance[0].id]})
# Name the instance 'MyGroovyInstance' and give it the Group tag 'MyGroovyGroup'
#instance.create_tags({ tags: [{ key: 'Name', value: 'MyGroovyInstance' }, { key: 'Group', value: 'MyGroovyGroup' }]})
#puts instance.id
#puts instance.public_ip_address

