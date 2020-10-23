
printf  "Increment 10 for a,b,c \n\t\t -> "
curl -X POST \
-H 'Content-Type: application/json' \
-d '{"labels": ["a", "b", "c"], "increment": 10}' \
http://localhost:4000/metrics
echo

printf "Increment 2 for a,b,c \n\t\t -> "
curl -X POST \
-H 'Content-Type: application/json' \
-d '{"labels": ["a", "b", "c"], "increment": 2}' \
http://localhost:4000/metrics
echo

printf "Increment 8 for a,b,c \n\t\t -> "
curl -X POST \
-H 'Content-Type: application/json' \
-d '{"labels": ["a", "b", "c"], "increment": 8}' \
http://localhost:4000/metrics
echo

printf "Increment 50 for w \n\t\t -> "
curl -X POST \
-H 'Content-Type: application/json' \
-d '{"labels": ["w"], "increment": 50}' \
http://localhost:4000/metrics
echo

printf  "Get CurrentState \n\t\t -> "
curl -X GET  \
http://localhost:4000/metrics
echo

printf  "Query a,b,c \n\t\t -> "
curl -X GET  \
http://localhost:4000/metrics/query\?expression=a,b,c
echo

printf  "Query w,z \n\t\t -> "
curl -X GET  \
http://localhost:4000/metrics/query\?expression=w,z
echo

printf  "Query e,f  \n\t\t -> "
curl -X GET  \
http://localhost:4000/metrics/query\?expression=e,f