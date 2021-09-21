# Build

The docker image contains all the dependencies to run this project.

To build the docker image locally and be able to use it in the next steps, use:

```sh
docker build -t project .
```

# Run deploy

Run the playbook `deploy.yml` to deploy a k8s cluster using LKE on Linode.
This project directory is mounted as a volume to docker container to persist configuration generated from the LKE cluster.

```sh
docker run -v $(pwd):/ansible --rm project deploy.yml -e linode_api_token=<YOUR_LINODE_API_TOKEN>
```

The playbook will get the kubeconfig to use the k8s cluster from terraform. a copy of kubeconfig.yml will be stored in {{ playbook_dir }}

# Manage cluster resources

Run the playbook `manage.yml` to deploy and manage

- cert-manager (helm)
- ingress-nginx (helm)
- letsencrypt issuers for staging and prd
- wordpress deployments (helm) with TLS

```sh
docker run -v $(pwd):/ansible --rm project:latest manage.yml
```

# Wordpress deployments

Wordpress deployments can be managed by `wordpress_deployments` in [vars/main.yml](vars/main.yml)

The following config will run a wordpress deployment using helm using domain `alpha.mydomain.com` and manage a TLS cert using letsencrypt. Ingress is routed via the shared ingress loadbalacer managed by `ingress-nginx`

```yml
wordpress_deployments:
  - name: alpha
    domain_name: alpha.domain.com
    service_type: ClusterIP
    cluster_issuer: letsencrypt-prd
    state: present
```

# Run destroy

Run the playbook `destroy.yml` to destroy the k8s LKE cluster on Linode.

**This step cannot be reverted and the cluster is beyond recovery**

```sh
docker run -v $(pwd):/ansible --rm project:latest destroy.yml
```
