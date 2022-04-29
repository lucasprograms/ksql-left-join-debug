### Steps to recreate

- `docker-compose up -d`
- `docker exec -it postgres /bin/bash`
- `psql -U postgres-user customers`
- execute SQL in `sql/customer-setup.sql`
- open a new terminal window
- execute the command in `connector-config.sh`
- `docker exec -it ksqldb-cli ksql http://ksqldb-server:8088`
- execute ksql in `sql/ksql-setup.sql`
- `select * from t_customer_potato_graceless;`
  - left join nulls were eagerly emitted, there are 4 rows
- `select * from t_customer_potato_graceful;`
  - expected: because there is a grace period of 0 seconds defined, left join nulls are eagerly emitted
  - actual: there is a single row for sue, the customers without potatoes do not have any rows
