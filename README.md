# DistributedCounter
It is POC how to implement distributed Counter on elixir(Erlang VM).

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


### Explanation 
I have chosen phoenix because it provides fast development. For the web part, there is no much to explain. On the contrary, the distributed part was more challenging for me. These are my decisions for this POC from beginning to now order by time.

* To hold state, I have implemented a GenServer that stores and maintains counter operations.
 -> it's state -> %{label: count}
* Supervisor of the counter process was added to provide fault tolerance. It starts when the server started and creates a counter process and links itself.
* Since to reach an easy counter process, I have added process registry and counter-records to it when started(via tuple).

Until this stage, Counter only works one node not distributed.

**I met a few challenges to run distributed it**

1. Counter's state must be consistent, so I think one process should handle it. But the nodes which don't have a counter process must know Pid to reach it, and nodes must be connected already each other.
2. I know erlang nodes can easily connect each other, But I need auto-discovery and connection mechanisms. Otherwise, connecting each other manually not feasible. (try to connect each node Node.ping(1), Node.ping(2) ...) 
3. Which node should hold the Counter process, and how should it be started? If all nodes start the counter process and register global connection, they cause conflict and cannot connect.

* To cope with the first challenge, I have decided to use an erlang global name registration facility that provides a distributed name registry. In contrast Registry module is not a cluster-aware registry; therefore, I removed it. (Process Discovery)

* To handle the second challenge, I have implemented a scheduled job that read cluster-info from config and tries discovery and connects nodes in the interval. It starts before the phoenix server started.

* For the last challenge. I have decided the counter process should not start auto when the server is started. Therefore I have changed its supervisor to dynamic. When the first request comes, The Node tries to find a counter process in the global registry. If not exist, it creates and registers globally.

### Assessment
Yeap, I know this is not a perfect and autonomous solution because it depends on many things.
