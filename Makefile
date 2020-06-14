include .env

tf-remote-state:
	@echo "[+] Provisioning infrastructure"
	cd remote-state; \
		terraform init && terraform apply

tf-apply:
	@echo "[+] Provisioning infrastructure"
	terraform init && terraform apply

tf-destroy:
	@echo "[+] Destroying infrastructure"
	terraform destroy

tf-output:
	@echo "[+] Terraform outpus"
	terraform output

provision-graylog:
	@echo "[+] Provisioning graylog"
	@GRAYLOG_IP_ADDR=$$(cd infra; terraform output | grep graylog_public | cut -d " " -f 3); \
		cd conf-mngt ; \
		echo "$${GRAYLOG_IP_ADDR}" ; \
		ansible-playbook -i "$${GRAYLOG_IP_ADDR}", graylog.yml
