

ssh-keygen -f citinova-key-ecdsa

cat citinova-key-ecdsa.pub

citinovadev@gmail.com
Citinova342
https://gitlab.com/citinovadev/test-openshift.git



oc get bc
# exportar pipeline para arquivo para adequação a novo projeto 
oc get --export bc  -o yaml -n admin-cicd tasks-pipeline  > teste-1.yaml
# criar pipeline
oc create -f gitlab-pipeline.yaml -n citinova-devops-tools
oc delete bc gitlab-pipeline

oc get --export bc  -o yaml -n admin-cicd tasks-pipeline  > teste-1.yaml
oc get --export bc  -o yaml -n citinova-devops-tools gitlab-pipeline  > gitlab-pipeline-2.yaml


oc get --export bc  -o yaml -n citinova-devops-tools tasks-pipeline > tasks-pipeline-1.yaml
oc delete sa -n citinova-devops-tools tasks-pipeline
oc create -f tasks-pipeline-1.yaml -n citinova-devops-tools

oc create -f gitlab-pipeline.yaml -n citinova-devops-tools
oc create sa gitlab-teste
oc delete sa gitlab-teste

oc get --export bc  -o yaml -n citinova-devops-tools gitlab-pipeline > gitlab-pipeline.yaml
oc delete bc -n citinova-devops-tools gitlab-pipeline
oc create -f gitlab-pipeline.yaml -n citinova-devops-tools

oc create -f gitlab-pipeline-2.yaml -n citinova-devops-tools

#oc create -f vipro2-template.json -n citinova-test-openshift-dev
#oc export -o yaml --as-template=sefazce-vipro2 > sefazce-vipro2.yaml -n citinova-test-openshift-dev

#oc secrets new-basicauth gitlabsecret --username=citinovadev@gmail.com --password=Citinova342
#oc label secret gitlabsecret credential.sync.jenkins.openshift.io=true
#oc secrets link builder gitlabsecret

oc create secret generic gitlabsecret --from-literal=username=citinovadev@gmail.com --from-literal=password=Citinova342 -n citinova-devops-tools
oc label secret gitlabsecret credential.sync.jenkins.openshift.io=true
oc secrets link builder gitlabsecret
oc delete secret gitlabsecret -n citinova-devops-tools


oc create secret generic gitlabsecret1 --from-literal=username=citinovadev@gmail.com --from-literal=password=Citinova342 -n citinova-devops-tools
oc label secret gitlabsecret1 credential.sync.jenkins.openshift.io=true -n citinova-devops-tools
oc secrets link builder gitlabsecret1 -n citinova-devops-tools
oc delete secret gitlabsecret -n citinova-devops-tools

