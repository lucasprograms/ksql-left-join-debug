SET 'auto.offset.reset' = 'earliest';

CREATE STREAM s_potatoes WITH (
    kafka_topic = 'potatoes'
    , key_format = 'avro'
    , value_format = 'avro'
);

CREATE STREAM s_customers WITH (
    kafka_topic = 'customers'
    , value_format = 'avro'
    , key_format = 'avro'
);

CREATE TABLE t_customer_potato_graceful AS
SELECT
    CONCAT_WS('__' , CAST(snp.id AS varchar) , CAST(sta.id AS varchar)) AS key
    , LATEST_BY_OFFSET (snp.id , FALSE) AS id
    , LATEST_BY_OFFSET (snp.name , FALSE) AS name
    , LATEST_BY_OFFSET (sta.number_of_spots , FALSE) AS number_of_spots
    , LATEST_BY_OFFSET (snp.__source_txid , FALSE) AS __source_txid
    , LATEST_BY_OFFSET (snp.__source_db , FALSE) AS __source_db
FROM
    s_customers snp
    LEFT JOIN s_potatoes sta WITHIN 10 seconds GRACE PERIOD 0 seconds ON snp.id = sta.customer_id
GROUP BY CONCAT_WS('__' , CAST(snp.id AS varchar) , CAST(sta.id AS varchar));

CREATE TABLE t_customer_potato_graceless AS
SELECT
    CONCAT_WS('__' , CAST(snp.id AS varchar) , CAST(sta.id AS varchar)) AS key
    , LATEST_BY_OFFSET (snp.id , FALSE) AS id
    , LATEST_BY_OFFSET (snp.name , FALSE) AS name
    , LATEST_BY_OFFSET (sta.number_of_spots , FALSE) AS number_of_spots
    , LATEST_BY_OFFSET (snp.__source_txid , FALSE) AS __source_txid
    , LATEST_BY_OFFSET (snp.__source_db , FALSE) AS __source_db
FROM
    s_customers snp
    LEFT JOIN s_potatoes sta WITHIN 10 seconds ON snp.id = sta.customer_id
GROUP BY CONCAT_WS('__' , CAST(snp.id AS varchar) , CAST(sta.id AS varchar));

