VAR_CICD_PROJECT='citinova-devops-tools'
VAR_DEV_PROJECT='citinova-test-openshift-dev' 
VAR_STAGE_PROJECT='citinova-test-openshift-hom'

oc adm $ARG_OC_OPS new-project $VAR_DEV_PROJECT   --node-selector="env=citinova" --display-name=$VAR_DEV_PROJECT
oc adm $ARG_OC_OPS new-project $VAR_STAGE_PROJECT --node-selector="env=citinova" --display-name=$VAR_STAGE_PROJECT

sleep 2

oc $ARG_OC_OPS policy add-role-to-group edit system:serviceaccounts:$VAR_CICD_PROJECT -n $VAR_DEV_PROJECT

oc $ARG_OC_OPS policy add-role-to-group edit system:serviceaccounts:$VAR_CICD_PROJECT -n $VAR_STAGE_PROJECT


oc $ARG_OC_OPS adm policy add-role-to-user admin $ARG_USERNAME -n $VAR_DEV_PROJECT >/dev/null 2>&1
oc $ARG_OC_OPS adm policy add-role-to-user admin $ARG_USERNAME -n $VAR_STAGE_PROJECT >/dev/null 2>&1


oc $ARG_OC_OPS annotate --overwrite namespace $VAR_DEV_PROJECT   demo=openshift-cd-$PRJ_SUFFIX >/dev/null 2>&1
oc $ARG_OC_OPS annotate --overwrite namespace $VAR_STAGE_PROJECT demo=openshift-cd-$PRJ_SUFFIX >/dev/null 2>&1


oc $ARG_OC_OPS adm pod-network join-projects --to=$VAR_CICD_PROJECT $VAR_DEV_PROJECT $VAR_STAGE_PROJECT >/dev/null 2>&1

oc import-image wildfly --from=openshift/wildfly-120-centos7 --confirm -n $VAR_DEV_PROJECT 
# dev
oc new-build --name=tasks --image-stream=wildfly:latest --binary=true -n $VAR_DEV_PROJECT
oc new-app tasks:latest --allow-missing-images -n $VAR_DEV_PROJECT
oc set triggers dc -l app=tasks --containers=tasks --from-image=tasks:latest --manual -n $VAR_DEV_PROJECT

# stage
oc new-app tasks:stage --allow-missing-images -n $VAR_STAGE_PROJECT
oc set triggers dc -l app=tasks --containers=tasks --from-image=tasks:stage --manual -n $VAR_STAGE_PROJECT

# dev project
oc expose dc/tasks --port=8080 -n $VAR_DEV_PROJECT
oc expose svc/tasks -n $VAR_DEV_PROJECT
oc set probe dc/tasks --readiness --get-url=http://:8080/ws/demo/healthcheck --initial-delay-seconds=30 --failure-threshold=10 --period-seconds=10 -n $VAR_DEV_PROJECT
oc set probe dc/tasks --liveness  --get-url=http://:8080/ws/demo/healthcheck --initial-delay-seconds=180 --failure-threshold=10 --period-seconds=10 -n $VAR_DEV_PROJECT
oc rollout cancel dc/tasks -n $VAR_STAGE_PROJECT

# stage project
oc expose dc/tasks --port=8080 -n $VAR_STAGE_PROJECT
oc expose svc/tasks -n $VAR_STAGE_PROJECT
oc set probe dc/tasks --readiness --get-url=http://:8080/ws/demo/healthcheck --initial-delay-seconds=30 --failure-threshold=10 --period-seconds=10 -n $VAR_STAGE_PROJECT
oc set probe dc/tasks --liveness  --get-url=http://:8080/ws/demo/healthcheck --initial-delay-seconds=180 --failure-threshold=10 --period-seconds=10 -n $VAR_STAGE_PROJECT
oc rollout cancel dc/tasks -n $VAR_DEV_PROJECT   