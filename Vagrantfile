VAGRANTFILE_API_VERSION = "2"
BOX_IMAGE = "fso/bionic64"
DEFAULT_PRV_MASTERIP = "10.0.0.20"
DEFAULT_PRV_WORKER1IP = "10.0.0.21"
DEFAULT_PRV_WORKER2IP = "10.0.0.22"
DEFAULT_PUB_MASTERIP = "192.168.1.240"
DEFAULT_PUB_WORKER1IP = "192.168.1.241"
DEFAULT_PUB_WORKER2IP = "192.168.1.242"

if ENV.has_key?('NETWORK') && ENV['NETWORK'].casecmp('public') == 0
    NETWORK = "public"
    if ENV.has_key?('MASTERIP') && ENV['MASTERIP'].length > 0
        MASTERIP = ENV['MASTERIP']
    else
        MASTERIP = DEFAULT_PUB_MASTERIP
    end
    if ENV.has_key?('WORKER1IP') && ENV['WORKER1IP'].length > 0
        WORKER1IP = ENV['WORKER1IP']
    else
        WORKER1IP = DEFAULT_PUB_WORKER1IP
    end
    if ENV.has_key?('WORKER2IP') && ENV['WORKER2IP'].length > 0
        WORKER2IP = ENV['WORKER2IP']
    else
        WORKER2IP = DEFAULT_PUB_WORKER2IP
    end
else
    NETWORK = "private"
    if ENV.has_key?('MASTERIP') && ENV['MASTERIP'].length > 0
        MASTERIP = ENV['MASTERIP']
    else
        MASTERIP = DEFAULT_PRV_MASTERIP
    end
    if ENV.has_key?('WORKER1IP') && ENV['WORKER1IP'].length > 0
        WORKER1IP = ENV['WORKER1IP']
    else
        WORKER1IP = DEFAULT_PRV_WORKER1IP
    end
    if ENV.has_key?('WORKER2IP') && ENV['WORKER2IP'].length > 0
        WORKER2IP = ENV['WORKER2IP']
    else
        WORKER2IP = DEFAULT_PRV_WORKER2IP
    end
end

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    config.vm.define "kubemaster" do |subconfig|
        subconfig.vm.box = BOX_IMAGE
        subconfig.vm.hostname = "kubemaster"
        if NETWORK == "public"
            subconfig.vm.network :public_network, ip: MASTERIP
        else
            subconfig.vm.network :private_network, ip: MASTERIP
        end
        subconfig.vm.provider :virtualbox do |vb|
            vb.name = "kubemaster"
            vb.customize ["modifyvm", :id, "--memory", "2048"]
            vb.customize ["modifyvm", :id, "--cpus", 2]
        end
        subconfig.vm.provision :shell, path: "kubemaster-provision.sh", env: {"MASTERIP" => MASTERIP}
    end
    config.vm.define "kubeworker1" do |subconfig|
        subconfig.vm.box = BOX_IMAGE
        subconfig.vm.hostname = "kubeworker1"
        if NETWORK == "public"
            subconfig.vm.network :public_network, ip: WORKER1IP
        else
            subconfig.vm.network :private_network, ip: WORKER1IP
        end
        subconfig.vm.provider :virtualbox do |vb|
            vb.name = "kubeworker1"
            vb.customize ["modifyvm", :id, "--memory", "1024"]
        end
        subconfig.vm.provision :shell, path: "kubeworker-provision.sh"
    end
    config.vm.define "kubeworker2" do |subconfig|
        subconfig.vm.box = BOX_IMAGE
        subconfig.vm.hostname = "kubeworker2"
        if NETWORK == "public"
            subconfig.vm.network :public_network, ip: WORKER2IP
        else
            subconfig.vm.network :private_network, ip: WORKER2IP
        end
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
