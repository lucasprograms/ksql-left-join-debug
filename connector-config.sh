curl --location --request POST 'localhost:28083/connectors' \
--header 'Content-Type: application/json' \
--data-raw '{
  "name": "customers.source.connector",
  "config": {
    "connector.class": "io.debezium.connector.postgresql.PostgresConnector",
    "plugin.name": "pgoutput",
    "database.server.name": "customers",
    "database.password": "postgres-pw",
    "database.port": "5432",
    "database.hostname": "postgres",
    "database.user": "postgres-user",
    "database.dbname": "customers",
    "slot.name": "customers",
    "table.include.list": "public.customers,public.potatoes",
    "transforms": "RerouteOtherTopics,Flatten,PatternRenameBefore,PatternRenameAfter,ReplaceField",
    "transforms.RerouteOtherTopics.type": "io.debezium.transforms.ByLogicalTableRouter",
    "transforms.RerouteOtherTopics.topic.regex": "^customers.public.(.+)$",
    "transforms.RerouteOtherTopics.topic.replacement": "$1",
    "transforms.Flatten.type": "org.apache.kafka.connect.transforms.Flatten$Value",
    "transforms.Flatten.delimiter": "_",
    "transforms.PatternRenameBefore.type": "com.github.jcustenborder.kafka.connect.transform.common.PatternRename$Value",
    "transforms.PatternRenameBefore.field.pattern": "^before",
    "transforms.PatternRenameBefore.field.replacement": "__before",
    "transforms.PatternRenameAfter.type": "com.github.jcustenborder.kafka.connect.transform.common.PatternRename$Value",
    "transforms.PatternRenameAfter.field.pattern": "^after_",
    "transforms.PatternRenameAfter.field.replacement": "",
    "transforms.ReplaceField.type": "org.apache.kafka.connect.transforms.ReplaceField$Value",
    "transforms.ReplaceField.renames": "source_db:__source_db,source_table:__source_table,source_schema:__source_schema,source_txId:__source_txId,source_lsn:__source_lsn,op:__op,ts_ms:__ts_ms"
  }
}
'