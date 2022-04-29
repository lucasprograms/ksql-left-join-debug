CREATE TABLE customers (
    id serial PRIMARY KEY
    , name text
    , age int
);

CREATE TABLE potatoes (
    id serial PRIMARY KEY
    , number_of_spots smallint DEFAULT 42
    , customer_id int NOT NULL REFERENCES customers (id)
);

ALTER TABLE customers REPLICA IDENTITY
    FULL;

ALTER TABLE potatoes REPLICA IDENTITY
    FULL;

BEGIN;
INSERT INTO customers (name , age)
    VALUES ('sue' , 25) , ('bill' , 51) , ('fred' , 34);
INSERT INTO potatoes (number_of_spots , customer_id)
    VALUES (17 , 1);
COMMIT;

