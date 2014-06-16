Vagrant.configure("2") do |config|
  # the base box this environment is built off of
  config.vm.box = 'precise32'

  # the url from where to fetch the base box if it doesn't exist
  config.vm.box_url = 'http://files.vagrantup.com/precise32.box'
  config.vm.hostname = "selbox"

  config.vm.network :private_network, ip: "192.168.2.200"
  config.vm.synced_folder "share/", "/home/vagrant",
  :nfs => false

  config.vm.provider :virtualbox do |v|
    v.customize ["modifyvm", :id, "--memory", 1024]
  end
  config.vm.provision :shell, :path => "setup.sh",
  run: "always"
end
