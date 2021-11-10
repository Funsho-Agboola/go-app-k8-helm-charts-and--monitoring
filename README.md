## PROJECT OVERVIEW

DEMO GO APP

The “Go-app” is run on a “3-node” K3s Kubernetes cluster hosted on civo and provisioned by terraform. The Cluster is named “uss-ari”. K3s cluster was implemented in this project as it is a purpose-built container orchestrator for running Kubernetes and it reduces the dependencies and steps needed to install, run and auto-update a production Kubernetes cluster. 

The app has been deployed for easy testing of the client-side frontend design and it gives room for monitoring and alerting for any issues. A prometheus server was deployed for the monitoring and collection of metrics from the application which can been made accessible externally. 

This application is containerized and shipped into a new cluster. HPA has also been employed to ensure high availability when required. 


## ARCHITECTURE DIAGRAM.

![](https://res.cloudinary.com/dtvv1oyyj/image/upload/v1636577690/Screenshot_from_2021-11-10_08-32-41.png)


## ENDPOINTS.

The Application exposes 3 endpoints
1. https://198b0948-6e16-4e90-9e3a-9323625dac2b.k8s.civo.com/demo/hello for the demo application.

![](https://res.cloudinary.com/dtvv1oyyj/image/upload/v1636578128/Screenshot_from_2021-11-10_08-36-46.png)

2. https://198b0948-6e16-4e90-9e3a-9323625dac2b.k8s.civo.com/metrics to exposes the metrics on the /metrics endpoint.

![](https://res.cloudinary.com/dtvv1oyyj/image/upload/v1636578036/Screenshot_from_2021-11-10_01-24-18.png)
 and

3. https://198b0948-6e16-4e90-9e3a-9323625dac2b.k8s.civo.com/random-error, if randomly, something goes wrong.

![](https://res.cloudinary.com/dtvv1oyyj/image/upload/v1636578139/Screenshot_from_2021-11-10_08-38-19.png)


## SETTING UP

Containerizing the application with Docker.

A multi-staged dockerfile was used to create an image of the application which was then put on dockerhub (a container registry). Multi-staged dockerfiles are more optimized and are always smaller in size.

One of the main benefits of Kubernetes is the high availability. Deployments have been used here to allow upgrades without downtime. 

The service is used to expose the deployment and Ingress routes traffic to the Backend (service).

The pods of the deployment that match a label selector can then forward traffic to the Consistent IP address.

The Deployment.yaml, hpa.yaml, svc.yaml, ingress.yaml, cluster-issuer.yaml and certificate.yaml manifests were created for proper functionality of the system.


MONITORING

Monitoring is an important part of the maintenance of a Kubernetes cluster to gain visibility on the infrastructure and the running applications and also to consequently detect undesirables behaviours like service downtime, errors and slow responses.

The implementation of `Prometheus` and `Grafana` are a common combination of tools to build up a monitoring system where Prometheus acts as a data collector pulling periodically, metrics from different systems and Grafana serves as the dashboard solution visualizing the data.

In the project, Prometheus, Grafana and Blackbox were installed using helm. Prometheus has been configured in a way to match the requirements and some pre-confiured scrape configs. The `values.yaml` file contains the configuration to scrape the metrics from the `demo-go-app` service. It was installed using;

```bash
helm install prometheus ./prometheus -n prometheus
```
A prometheus namespace is being created for the monitoring and prometheus itself, properly deployed can easily be accessed by port-forwarding a local port to that of the server (9090).

![](https://res.cloudinary.com/dtvv1oyyj/image/upload/v1636578240/Screenshot_from_2021-11-10_08-53-53.png)

![](https://res.cloudinary.com/dtvv1oyyj/image/upload/v1636578249/Screenshot_from_2021-11-10_08-54-02.png)

One can then scrape application Metrics like “http_request_duration_microseconds”, “http_request_size_bytes”, “http_server_resp_time_bucket” etc.

![](https://res.cloudinary.com/dtvv1oyyj/image/upload/v1636578358/Screenshot_from_2021-11-10_08-58-32.png)

The implementation of the Blackbox exporter which is a tool that allows for the monitoring of HTTP, DNS, TCP and ICMP endpoints is also configured to be visualized on Grafana. The `values.yaml` file contains some pre-configured configuration for prometheus and HTTP endpoints to monitor. That of grafana contains the configuration to connect with prometheus service and included some custom dashboards. They were also included using;

To install the blackbox-exporter helm chart
```bash
helm install blackbox-exporter prometheus-blackbox-exporter -n prometheus
```
To install the grafana helm chart

```bash
helm install grafana ./grafana -n prometheus
```
Grafana can easily be accessed by port-forwarding a local port to that of the server (3000).


TERRAFORM

Basically provisioning the infrastructure with terraform:

To initialize terraform state

``` terraform init```

To plan and see changes to be applied:

```terraform plan```

To provision the changes to civo:
```terraform apply```


CERTIFICATE AND ISSUER

Cert-manager runs within the Kubernetes cluster. It utilizes CustomResourceDefinitions to configure Certificate Authorities and certificates requests. The certificate has been created using letsencrypt issuer and is due to expire in about 2 months and 4 days as shown on the grafana UI.

![](https://res.cloudinary.com/dtvv1oyyj/image/upload/v1636578456/Screenshot_from_2021-11-07_18-16-57.png)

Install the cert-manager to issue certificates from letsencrypt to enable SSL for the `demo-go-app`. The `cluster-issuer` and `certificate` resources are included;

helm install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --version v1.6.0 \
  --set installCRDs=true


## RECOMMENDATIONS

A few problems in the design and recommendations for them are that;
1. Currently the api server access is open to the world it would be better to restrict access for a particular ip addresses.

2. It is of a better practice to build the docker image and deploy through Continious intergration/Continous Delivery.

3. Tools like prometheus/grafana/blackbox exporter could be installed using either Terraform or CI/CD techniques



## CONTRIBUTING

To contribute to this project, make a pull request with a concise commit message and I will go through, thanks!
