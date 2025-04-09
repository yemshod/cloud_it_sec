
ENV ?= dev

init:
	./scripts/init.sh $(ENV)

plan:
	cd envs/$(ENV) && terraform plan -var-file=terraform.tfvars

apply:
	./scripts/apply.sh $(ENV)

destroy:
	cd envs/$(ENV) && terraform destroy -var-file=terraform.tfvars
