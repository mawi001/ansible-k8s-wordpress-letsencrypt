FROM mwillemsma/docker-ansible-dev:latest
ENV ANSIBLE_FORCE_COLOR=1
WORKDIR /ansible

RUN ansible-galaxy collection install community.kubernetes:2.0.0
RUN pip3 install openshift==0.12.1
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
kubectl version --client
RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 && \
chmod 700 get_helm.sh && \
./get_helm.sh && \
helm version
ENTRYPOINT ["ansible-playbook", "-v"]
