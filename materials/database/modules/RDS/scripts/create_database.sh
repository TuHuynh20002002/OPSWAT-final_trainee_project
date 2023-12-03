psql -h $HOST \
     -p $PORT \
     -U $USERNAME \
     -d $DATABASE \
     -c 'CREATE TABLE todo (todo_id SERIAL PRIMARY KEY, description VARCHAR(255));'