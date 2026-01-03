op run --env-file=.env.tpl -- terraform state rm kubernetes_namespace_v1.cert_manager || true
op run --env-file=.env.tpl -- terraform destroy # -auto-approve
rm ~/.ssh/known_hosts