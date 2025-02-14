Vagrant.configure("2") do |config|
  
  #box do ubuntu
  config.vm.box = "ubuntu/focal64"
  
  #recursos que será utilizado
  config.vm.provider "virtualbox" do |vb|
    vb.name = "maquina_vagrant"
    vb.memory= 1024
    vb.cpus = 1
  end
  
  #configurações de network e script
  config.vm.network "public_network", ip: "192.168.3.77"
  config.vm.provision "shell", path: "script.sh"

end
