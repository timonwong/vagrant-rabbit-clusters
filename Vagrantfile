# -*- mode: ruby -*-
# vi: set ft=ruby :

#!! REQUIRES !! vagrant-hostmanager

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = '2'

BOXES = [
  { name: :rabbit1, ip: '10.10.0.101', node_type: :disc, },
  { name: :rabbit2, ip: '10.10.0.102', node_type: :disc, },
  { name: :rabbit3, ip: '10.10.0.103', node_type: :ram, },
]

MAIN_NODE = :rabbit1
RABBIT_NODES = BOXES.map {|v| "'rabbit@#{v[:name].to_s}'" }

PARTITION_HANDLING_MODE = :pause_minority
RABBITMQ_CONFIG_TEMPLATE = File.read('config/rabbitmq.config.template')


Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = 'centos63'

  config.vm.synced_folder '../', '/vagrant'
  config.vm.synced_folder 'config', '/v-config'

  # Hostmanager config
  config.vm.provision :hostmanager
  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.ignore_private_ip = false
  config.hostmanager.include_offline = true

  config.vm.provider :virtualbox do |vb|
    vb.customize ['modifyvm', :id, '--cpus', '1']
    vb.customize ['modifyvm', :id, '--memory', '1024']
    vb.customize ['modifyvm', :id, '--natdnshostresolver1', 'on']
    vb.customize ['setextradata', :id, 'VBoxInternal2/SharedFoldersEnableSymlinksCreate/vagrant', '1']
  end

  BOXES.each do |opts|
    config.vm.define opts[:name] do |config|
      config.vm.hostname = opts[:name].to_s

      config.vm.network :private_network, ip: opts[:ip], netmask: '255.255.255.0'

      config.vm.provision :shell, path: "scripts/base.sh"
      config.vm.provision :shell, path: "scripts/setup_rabbit_common.sh"

      config_fn = "config/#{opts[:name]}.rabbitmq.config"
      File.open(config_fn, 'w') do |file|
        file.write(RABBITMQ_CONFIG_TEMPLATE % {
          partition_handling_mode: PARTITION_HANDLING_MODE,
          nodes: RABBIT_NODES.join(', '),
          node_type: opts[:node_type],
        })
      end

      config.vm.provision :shell, inline:
        "cp /v-config/#{opts[:name]}.rabbitmq.config /etc/rabbitmq/rabbitmq.config && chmod 644 /etc/rabbitmq/rabbitmq.config"

      config.vm.provision :shell, inline: 'service rabbitmq-server start'
    end
  end
end
