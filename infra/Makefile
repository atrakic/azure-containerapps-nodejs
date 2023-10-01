test:
	az ad signed-in-user show || az login
	az account show
	terraform init -backend=false -upgrade
	terraform validate
	terraform plan -lock=false -var-file test.tfvars -out tf.out
	docker run --rm -v $$PWD:/target -it eerkunt/terraform-compliance -f features -p tf.out

clean:
	rm -rf .terraform
