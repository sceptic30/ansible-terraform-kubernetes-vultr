resource "null_resource" "ansible-provision" {
  depends_on = [vultr_instance.k8s-master, vultr_instance.k8s-node]

  provisioner "local-exec" {
    command = "echo \"[kubernetes-master]\n${vultr_instance.k8s-master.hostname} ansible_ssh_host=${vultr_instance.k8s-master.main_ip}\" > ansible/inventory"
  }

  provisioner "local-exec" {
    command = "echo \"\n[kubernetes-nodes]\" >> ansible/inventory"
  }

  provisioner "local-exec" {
    command = "echo \"${join("\n", formatlist("%s ansible_ssh_host=%s", vultr_instance.k8s-node.*.hostname, vultr_instance.k8s-node.*.main_ip))}\" >> ansible/inventory"
  }

   provisioner "local-exec" {
    command = "echo \"apiVersion: v1\nkind: ConfigMap\nmetadata:\n  namespace: metallb-system\n  name: config\ndata:\n  config: |\n    address-pools:\n    - name: default\n      protocol: layer2\n      addresses:\n      - ${vultr_instance.k8s-master.main_ip}-${vultr_instance.k8s-node[var.node_number - 1].main_ip}\" > metallb/metal-lb.yaml"
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i ansible/inventory -u root --private-key keys/id_ed25519 ansible/k8s-master-playbook.yaml"
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i ansible/inventory -u root --private-key keys/id_ed25519 ansible/k8s-node-playbook.yaml"
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i ansible/inventory -u root --private-key keys/id_ed25519 ansible/k8s-devops-stack-playbook.yaml"
  }
}
