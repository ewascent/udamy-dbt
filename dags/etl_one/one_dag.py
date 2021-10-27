import datetime

from airflow import DAG
# from airflow_dbt.operators.dbt_operator import DbtSnapshotOperator, DbtRunOperator
from airflow.operators.http_operator import SimpleHttpOperator

from airflow.utils.dates import days_ago

defaul_args = {
    'dir': '',
    'run_date': datetime.datetime.now(),
    'start_date': days_ago(1)
}

with DAG() as dag:
