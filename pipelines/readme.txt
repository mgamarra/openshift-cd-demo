

ssh-keygen -f citinova-key-ecdsa

cat citinova-key-ecdsa.pub

citinovadev@gmail.com
Citinova342
https://gitlab.com/citinovadev/test-openshift.git



oc get bc
# exportar pipeline para arquivo para adequação a novo projeto 
oc get --export bc  -o yaml -n admin-cicd tasks-pipeline  > teste-1.yaml
# criar pipeline
oc create -f gitlab-pipeline.yaml 
oc delete bc gitlab-pipeline

oc get --export bc  -o yaml -n admin-cicd tasks-pipeline  > teste-1.yaml
oc get --export bc  -o yaml -n citinova-devops-tools gitlab-pipeline  > gitlab-pipeline-2.yaml

oc create sa gitlab-teste
oc delete sa gitlab-teste


#oc secrets new-basicauth gitlabsecret --username=citinovadev@gmail.com --password=Citinova342
#oc label secret gitlabsecret credential.sync.jenkins.openshift.io=true
#oc secrets link builder gitlabsecret

oc create secret generic gitlabsecret --from-literal=username=citinovadev@gmail.com --from-literal=password=Citinova342 -n citinova-devops-tools
oc label secret gitlabsecret credential.sync.jenkins.openshift.io=true
oc secrets link builder gitlabsecret
oc delete secret gitlabsecret -n citinova-devops-tools

