# Deploy a Kubernetes Cluster with any number of nodes on Vultr, using Terraform and Ansible.
## Usage
1. Download the repository with: ``` git clone https://github.com/sceptic30/ansible-terraform-kubernetes-vultr.git ```
2. Install the whois pagkage in your local machine with ``` sudo apt install whois ``` and generate a hashed password for your desired username like so:
``` mkpasswd --method=sha-512 some_password ``` and copy the hash to ansible vars file located in **ansible/vars.yaml**. Add the other details as well.
3. cd to ansible-terraform-kubernetes-vultr folder, and change permissions of the **keys** folder to ***700*** with ```chmod 700 -R keys```. If the keys are assessible by other users ansible will not be able to connect to the remote machine and will exit with an exit 4 status code.
4. cd to they **keys** folder, and create your private-public key pair by executing the command: 
``` $ ssh-keygen -t ed25519 -C "your_email@example.com" ```
The id_ed25519.pub key will be uploaded to your Vultr account, and will be used while servers are provisioned.
5. Run ./install.sh 

## LoadBalancer
The MetalLB loadbalancer will be autoconfigured by using the IP of the Master Node.
When the installation finish, will see something like:
```
$ kubectl get service -n nginx-ingress
NAME            TYPE           CLUSTER-IP    EXTERNAL-IP   PORT(S)                      AGE
nginx-ingress   LoadBalancer   10.100.67.5   45.76.39.72   80:32735/TCP,443:32094/TCP   5m17s
```
## DNS Entries
DNS entries for Jenkins, Grafana, Prometheus, and Alert Manager are auto-configured as well.

## Pod Network
Flunnel is included out of the box, but you have the option to use Calico by editing the appropriate task in ansible/k8s-master-playbook.yaml.