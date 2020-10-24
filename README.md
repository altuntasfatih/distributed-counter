# DistributedCounter
İt is poc how to implement distributed counter on elixir(erlang vm).

## To setup
  * Install dependencies with `mix deps.get`
  * Test with  `mix test`

### To run 
 * Start Appllication with `./run.sh` it starts three phoenix server from 4000 to 4002
 
### Endpoints
* GET   /metrics                                           -> Get current state of counter.
* POST  /metrics                                           -> Increment counter.
* GET   /metrics/query?expression=                         -> Query for counterlabes.
<br> Not -> `test.sh and test_distributed.sh` contains curl requests to test endpoints.
