SHELL = /bin/bash

CONFIG_FILE := config/envvars.json

$(eval KUBECTL_INSTALLER_PATH=$(shell jq '.Parameters.KubeCtlInstallerPath' ${CONFIG_FILE}))
$(eval MINIKUBE_INSTALLER_PATH=$(shell jq '.Parameters.MinikubeInstallerPath' ${CONFIG_FILE}))

installations: deps install clean

.PHONY: deps
deps:
	$(info [+] Download the relevant dependencies)
	#pip install jq -q
	# Download kubectl, instructions here: https://kubernetes.io/docs/tasks/tools/install-kubectl-macos/#install-kubectl-binary-with-curl-on-macos
	@curl -L ${KUBECTL_INSTALLER_PATH} -o tmp/kubectl --silent && chmod +x tmp/kubectl && sudo mv tmp/kubectl /usr/local/bin/kubectl
	# Download Minikube, instructions here: https://minikube.sigs.k8s.io/docs/start/
	@curl -L ${MINIKUBE_INSTALLER_PATH} -o tmp/minikube_installer --silent && sudo install tmp/minikube_installer /usr/local/bin/minikube
	# Download Helm
	@curl -L https://get.helm.sh/helm-v3.8.2-darwin-amd64.tar.gz -o tmp/helm_installer.gz
	@tar -zxvf tmp/helm_installer.gz -C tmp/ && mv tmp/darwin-amd64/helm /usr/local/bin/helm
	# Download kubectx &kubens
	# mac-command: brew install kubectx
	@sudo git clone https://github.com/ahmetb/kubectx /opt/kubectx
	@sudo ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx
	@sudo ln -s /opt/kubectx/kubens /usr/local/bin/kubens
	# Install kubetail
	@brew tap johanhaleby/kubetail && brew install kubetail

.PHONY: install
install:
	$(info [+] Install the relevant dependencies)

.PHONY: clean
clean:
	$(info [+] Remove any redundant files, e.g. downloads)
	@rm tmp/minikube_installer
	@rm tmp/helm_installer.gz
	@rm -r tmp/darwin-amd64

beep:
	# Download kubectx &kubens
	sudo git clone https://github.com/ahmetb/kubectx /opt/kubectx
	sudo ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx
	sudo ln -s /opt/kubectx/kubens /usr/local/bin/kubens

hey:
	brew tap johanhaleby/kubetail && brew install kubetail
