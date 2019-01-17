VAGRANTFILE_API_VERSION = "2"
BOX_IMAGE = "fso/bionic64"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    config.vm.define "kubemaster" do |subconfig|
        subconfig.vm.box = BOX_IMAGE
        subconfig.vm.hostname = "kubemaster"
        subconfig.vm.network :public_network, ip: "192.168.1.240"
        subconfig.vm.provider :virtualbox do |vb|
            vb.name = "kubemaster"
            vb.customize ["modifyvm", :id, "--memory", "2048"]
            vb.customize ["modifyvm", :id, "--cpus", 2]
        end
        subconfig.vm.provision :shell, path: "kubemaster-provision.sh"
    end
    config.vm.define "kubeworker1" do |subconfig|
        subconfig.vm.box = BOX_IMAGE
        subconfig.vm.hostname = "kubeworker1"
        subconfig.vm.network :public_network, ip: "192.168.1.241"
        subconfig.vm.provider :virtualbox do |vb|
            vb.name = "kubeworker1"
            vb.customize ["modifyvm", :id, "--memory", "1024"]
        end
        subconfig.vm.provision :shell, path: "kubeworker-provision.sh"
    end
    config.vm.define "kubeworker2" do |subconfig|
        subconfig.vm.box = BOX_IMAGE
        subconfig.vm.hostname = "kubeworker2"
        subconfig.vm.network :public_network, ip: "192.168.1.242"
        subconfig.vm.provider :virtualbox do |vb|
            vb.name = "kubeworker2"
            vb.customize ["modifyvm", :id, "--memory", "1024"]
        end
        subconfig.vm.provision :shell, path: "kubeworker-provision.sh"
    end
    config.vm.provision "shell", inline: <<-SHELL
        apt-get update
        apt-get install -y apt-transport-https
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
        add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
        curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add
        echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list
        apt-get update
        apt-get install -y docker-ce
        usermod -aG docker vagrant
        systemctl start docker
        systemctl enable docker
        apt-get install -y kubelet kubeadm kubectl kubernetes-cni
        swapoff -a
        sed -i -e 's/^\(.*swap.*\)/#\1/g' /etc/fstab
    SHELL
end
