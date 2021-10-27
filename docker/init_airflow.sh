python -m pip install -f ../requirements.txt

airflow connections --add --conn_id reporting_postgres --conn_login airflow --conn_host postgres --conn_password airflow --conn_schema airflow --conn_type postgres --conn_port 5432
airflow variables --set to_email_address bubba@cambia.com
airflow variables --set airflow_user airflow_user
airflow variables --set airflow_pg_reporting_conn_name reporting_postgres
airflow pool -s default_pool 128 'default pool'
