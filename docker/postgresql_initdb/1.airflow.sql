CREATE SCHEMA IF NOT EXISTS airflow AUTHORIZATION airflow;

create table if not exists airflow.alembic_version
(
	version_num varchar(32) not null
		constraint alembic_version_pkc
			primary key
);

alter table airflow.alembic_version owner to airflow;

create table if not exists airflow.connection
(
	id serial not null
		constraint connection_pkey
			primary key,
	conn_id varchar(250),
	conn_type varchar(500),
	host varchar(500),
	schema varchar(500),
	login varchar(500),
	password varchar(5000),
	port integer,
	extra varchar(5000),
	is_encrypted boolean,
	is_extra_encrypted boolean
);

alter table airflow.connection owner to airflow;

create table if not exists airflow.dag
(
	dag_id varchar(250) not null
		constraint dag_pkey
			primary key,
	is_paused boolean,
	is_subdag boolean,
	is_active boolean,
	last_scheduler_run timestamp with time zone,
	last_pickled timestamp with time zone,
	last_expired timestamp with time zone,
	scheduler_lock boolean,
	pickle_id integer,
	fileloc varchar(2000),
	owners varchar(2000),
	description text,
	default_view varchar(25),
	schedule_interval text,
	root_dag_id varchar(250)
);

alter table airflow.dag owner to airflow;

create index if not exists  idx_root_dag_id
	on airflow.dag (root_dag_id);

create table if not exists airflow.dag_pickle
(
	id serial not null
		constraint dag_pickle_pkey
			primary key,
	pickle bytea,
	created_dttm timestamp with time zone,
	pickle_hash bigint
);

alter table airflow.dag_pickle owner to airflow;

create table if not exists airflow.import_error
(
	id serial not null
		constraint import_error_pkey
			primary key,
	timestamp timestamp with time zone,
	filename varchar(1024),
	stacktrace text
);

alter table airflow.import_error owner to airflow;

create table if not exists airflow.job
(
	id serial not null
		constraint job_pkey
			primary key,
	dag_id varchar(250),
	state varchar(20),
	job_type varchar(30),
	start_date timestamp with time zone,
	end_date timestamp with time zone,
	latest_heartbeat timestamp with time zone,
	executor_class varchar(500),
	hostname varchar(500),
	unixname varchar(1000)
);

alter table airflow.job owner to airflow;

create index if not exists  idx_job_state_heartbeat
	on airflow.job (state, latest_heartbeat);

create index if not exists  job_type_heart
	on airflow.job (job_type, latest_heartbeat);

create table if not exists airflow.known_event_type
(
	id serial not null
		constraint known_event_type_pkey
			primary key,
	know_event_type varchar(200)
);

alter table airflow.known_event_type owner to airflow;

create table if not exists airflow.log
(
	id serial not null
		constraint log_pkey
			primary key,
	dttm timestamp with time zone,
	dag_id varchar(250),
	task_id varchar(250),
	event varchar(30),
	execution_date timestamp with time zone,
	owner varchar(500),
	extra text
);

alter table airflow.log owner to airflow;

create index if not exists  idx_log_dag
	on airflow.log (dag_id);

create table if not exists airflow.sla_miss
(
	task_id varchar(250) not null,
	dag_id varchar(250) not null,
	execution_date timestamp with time zone not null,
	email_sent boolean,
	timestamp timestamp with time zone,
	description text,
	notification_sent boolean,
	constraint sla_miss_pkey
		primary key (task_id, dag_id, execution_date)
);

alter table airflow.sla_miss owner to airflow;

create index if not exists  sm_dag
	on airflow.sla_miss (dag_id);

create table if not exists airflow.slot_pool
(
	id serial not null
		constraint slot_pool_pkey
			primary key,
	pool varchar(50)
		constraint slot_pool_pool_key
			unique,
	slots integer,
	description text
);

alter table airflow.slot_pool owner to airflow;

create table if not exists airflow.task_instance
(
	task_id varchar(250) not null,
	dag_id varchar(250) not null,
	execution_date timestamp with time zone not null,
	start_date timestamp with time zone,
	end_date timestamp with time zone,
	duration double precision,
	state varchar(20),
	try_number integer,
	hostname varchar(1000),
	unixname varchar(1000),
	job_id integer,
	pool varchar(50) not null,
	queue varchar(256),
	priority_weight integer,
	operator varchar(1000),
	queued_dttm timestamp with time zone,
	pid integer,
	max_tries integer default '-1'::integer,
	executor_config bytea,
	constraint task_instance_pkey
		primary key (task_id, dag_id, execution_date)
);

alter table airflow.task_instance owner to airflow;

create index if not exists  ti_dag_state
	on airflow.task_instance (dag_id, state);

create index if not exists  ti_state
	on airflow.task_instance (state);

create index if not exists  ti_job_id
	on airflow.task_instance (job_id);

create index if not exists  ti_state_lkp
	on airflow.task_instance (dag_id, task_id, execution_date, state);

create index if not exists  ti_dag_date
	on airflow.task_instance (dag_id, execution_date);

create index if not exists  ti_pool
	on airflow.task_instance (pool, state, priority_weight);

create table if not exists airflow.users
(
	id serial not null
		constraint user_pkey
			primary key,
	username varchar(250)
		constraint user_username_key
			unique,
	email varchar(500),
	password varchar(255),
	superuser boolean
);

alter table airflow.users owner to airflow;

create table if not exists airflow.variable
(
	id serial not null
		constraint variable_pkey
			primary key,
	key varchar(250)
		constraint variable_key_key
			unique,
	val text,
	is_encrypted boolean
);

alter table airflow.variable owner to airflow;

create table if not exists airflow.chart
(
	id serial not null
		constraint chart_pkey
			primary key,
	label varchar(200),
	conn_id varchar(250) not null,
	user_id integer
		constraint chart_user_id_fkey
			references users,
	chart_type varchar(100),
	sql_layout varchar(50),
	sql text,
	y_log_scale boolean,
	show_datatable boolean,
	show_sql boolean,
	height integer,
	default_params varchar(5000),
	x_is_date boolean,
	iteration_no integer,
	last_modified timestamp with time zone
);

alter table airflow.chart owner to airflow;

create table if not exists airflow.known_event
(
	id serial not null
		constraint known_event_pkey
			primary key,
	label varchar(200),
	start_date timestamp,
	end_date timestamp,
	user_id integer
		constraint known_event_user_id_fkey
			references users,
	known_event_type_id integer
		constraint known_event_known_event_type_id_fkey
			references known_event_type,
	description text
);

alter table airflow.known_event owner to airflow;

create table if not exists airflow.xcom
(
	id serial not null
		constraint xcom_pkey
			primary key,
	key varchar(512),
	value bytea,
	timestamp timestamp with time zone not null,
	execution_date timestamp with time zone not null,
	task_id varchar(250) not null,
	dag_id varchar(250) not null
);

alter table airflow.xcom owner to airflow;

create index if not exists  idx_xcom_dag_task_date
	on airflow.xcom (dag_id, task_id, execution_date);

create table if not exists airflow.dag_run
(
	id serial not null
		constraint dag_run_pkey
			primary key,
	dag_id varchar(250),
	execution_date timestamp with time zone,
	state varchar(50),
	run_id varchar(250),
	external_trigger boolean,
	conf bytea,
	end_date timestamp with time zone,
	start_date timestamp with time zone,
	constraint dag_run_dag_id_run_id_key
		unique (dag_id, run_id),
	constraint dag_run_dag_id_execution_date_key
		unique (dag_id, execution_date)
);

alter table airflow.dag_run owner to airflow;

create index if not exists  dag_id_state
	on airflow.dag_run (dag_id, state);

create table if not exists airflow.task_fail
(
	id serial not null
		constraint task_fail_pkey
			primary key,
	task_id varchar(250) not null,
	dag_id varchar(250) not null,
	execution_date timestamp with time zone not null,
	start_date timestamp with time zone,
	end_date timestamp with time zone,
	duration integer
);

alter table airflow.task_fail owner to airflow;

create index if not exists  idx_task_fail_dag_task_date
	on airflow.task_fail (dag_id, task_id, execution_date);

create table if not exists airflow.kube_resource_version
(
	one_row_id boolean default true not null
		constraint kube_resource_version_pkey
			primary key
		constraint kube_resource_version_one_row_id
			check (one_row_id),
	resource_version varchar(255)
);

alter table airflow.kube_resource_version owner to airflow;

create table if not exists airflow.kube_worker_uuid
(
	one_row_id boolean default true not null
		constraint kube_worker_uuid_pkey
			primary key
		constraint kube_worker_one_row_id
			check (one_row_id),
	worker_uuid varchar(255)
);

alter table airflow.kube_worker_uuid owner to airflow;

create table if not exists airflow.task_reschedule
(
	id serial not null
		constraint task_reschedule_pkey
			primary key,
	task_id varchar(250) not null,
	dag_id varchar(250) not null,
	execution_date timestamp with time zone not null,
	try_number integer not null,
	start_date timestamp with time zone not null,
	end_date timestamp with time zone not null,
	duration integer not null,
	reschedule_date timestamp with time zone not null,
	constraint task_reschedule_dag_task_date_fkey
		foreign key (task_id, dag_id, execution_date) references task_instance
			on delete cascade
);

alter table airflow.task_reschedule owner to airflow;

create index if not exists  idx_task_reschedule_dag_task_date
	on airflow.task_reschedule (dag_id, task_id, execution_date);

create table if not exists airflow.serialized_dag
(
	dag_id varchar(250) not null
		constraint serialized_dag_pkey
			primary key,
	fileloc varchar(2000) not null,
	fileloc_hash integer not null,
	data json not null,
	last_updated timestamp with time zone not null
);

alter table airflow.serialized_dag owner to airflow;

create index if not exists  idx_fileloc_hash
	on airflow.serialized_dag (fileloc_hash);

create table if not exists airflow.dag_tag
(
	name varchar(100) not null,
	dag_id varchar(250) not null
		constraint dag_tag_dag_id_fkey
			references dag,
	constraint dag_tag_pkey
		primary key (name, dag_id)
);

alter table airflow.dag_tag owner to airflow;