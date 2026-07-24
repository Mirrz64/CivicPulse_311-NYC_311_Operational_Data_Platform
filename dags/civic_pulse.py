from datetime import datetime, timedelta

from airflow import DAG
from airflow.decorators import task
from airflow.providers.common.sql.operators.sql import SQLExecuteQueryOperator
from airflow.providers.microsoft.azure.hooks.data_factory import AzureDataFactoryHook

from include.transform import transform
from include.upload_raw_data import upload_data

default_args = {
    'owner': 'amdari',
    'depends_on_past': False,
    'start_date': datetime(2026, 7, 20),
    'retries': 1,
    'retry_delay': timedelta(minutes=1),
    'schedule_interval': '@hourly',
}

@task()
def extract_data_from_api():
    return upload_data()

@task()
def transform_data():
    return transform()

@task()
def run_azure_data_factory():
    # Use the Airflow Hook directly to send the trigger request safely
    hook = AzureDataFactoryHook(azure_data_factory_conn_id='azure_factory')
    response = hook.get_conn().pipelines.create_run(
        resource_group_name='civicpulse_resource',
        factory_name='civicpulse-factory',
        pipeline_name='CivicPulseDataFactory'
    )
    print(f"Successfully triggered ADF Pipeline! Run ID: {getattr(response, 'run_id', 'Triggered')}")


with DAG(dag_id='civic_pulse_dag', catchup=False, default_args=default_args):

    create_db_table = SQLExecuteQueryOperator(
        sql='sql/civic_pulse.sql',
        task_id='civic_pulse_table',
        conn_id='postgres_connection'
    )

    (
        extract_data_from_api() 
        >> transform_data() 
        >> create_db_table 
        >> run_azure_data_factory()
    )