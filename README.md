This is designed to demonstrate use of DBT in Airflow

## Required Technologies
1. Anaconda or miniconda
2. Docker Desktop and Docker Compose
3. Make

Make an Airflow Fernet Key
```
from cryptography.fernet import Fernet
fernet_key= Fernet.generate_key()
print(fernet_key.decode()) # your fernet_key, keep it in secured place!
```


Run one model
`dbt run --models example.incremental_time`

Run model based on given source
`dbt run --models source:sample+`

Run model based on given tag
`dbt run --model tag:nightly`

Run tests
`dbt test`

run snapshots
`dbt snapshot`

run a stand alone macro
`dbt run-operation suspend --args '{warehouse: my_wh}'`

## DBT Integration Models
* Install DBT on the Airflow cluster and use the DBT operator `airflow_dbt.operators.dbt_operator`. 
* Run DBT Cloud based DBT tasks from Airflow using the [community plugin](https://github.com/dwallace0723/dbt-cloud-plugin/blob/master/examples/dbt_cloud_hourly_dag.py)
* Run DBT Cloud based DBT tasks from Airflow using the standard HTTP operator `from airflow.providers.http.operators.http import SimpleHttpOperator` and the DBT API

## Reference Material
* [DBT Tutorial on Safari Books](https://katacoda.com/embed/orm-sam-bail/01_dbt)
* https://www.astronomer.io/blog/airflow-dbt-1
* https://www.astronomer.io/blog/airflow-dbt-2
* [DBT Tutorial](https://github.com/jeremyholtzman/jrtests-learn-dbt)
* https://docs.getdbt.com/docs/introduction/
* https://cambia.udemy.com/course/learn-dbt-from-scratch/learn/lecture/19209000#overview
* [DBT commands](https://docs.getdbt.com/reference/dbt-commands)
* [Blog 1](https://www.robin-beer.de/drafts/how-to-setup-dbt-dataops-with-gitlab-cicd-for-a-snowflake-cloud-data-warehouse.html)
* [DBT Cloud Operator for Airflow](https://github.com/dwallace0723/dbt-cloud-plugin/blob/master/examples/dbt_cloud_hourly_dag.py)
* [Sinter](https://github.com/dbt-labs/airflow-sinter-operator)
* [Airflow on DBT Cloud](https://towardsdatascience.com/creating-an-environment-with-airflow-and-dbt-on-aws-part-3-2789f35adb5d)
