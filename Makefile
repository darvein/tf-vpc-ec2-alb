include .env
export

tf-remote-state:
	@echo "[+] Provisioning infrastructure"
	cd remote-state; \
		terraform init && terraform apply

tf-apply:
	@echo "[+] Provisioning infrastructure"
	terraform init -reconfigure && terraform apply

tf-destroy:
	@echo "[+] Destroying infrastructure"
	terraform destroy

tf-output:
	@echo "[+] Terraform outpus"
	terraform output
