After running terraform, use the outputs to configure kubectl as follows:
~~~sh
aws eks --region $(terraform output -raw region) update-kubeconfig \
    --name $(terraform output -raw cluster_name)
~~~

