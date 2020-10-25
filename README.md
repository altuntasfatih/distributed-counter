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


### Explanation 
I have choosed phoenix because it provides fast development.For web part, there is no much to explain. On the contrary, distributed part was more challenging for me. These are my decisions for this poc from beginning to now order by time.

* To hold state I have implemented a GenServer that stores and maintains counter operations.
 -> it's state -> %{label: count}
* Supervisor of counter process was added to provide fault tolerance. It starts when server started and create counter process and link itself.
* Since to reach easly counter process, I have added process registry and counter records itself to it  when  started(via tuple).

Until this stage Counter only works one node not distributed.

**I met a few challenges to run distributed it**

1. Counter's state must be consistent so I think should one process handle it. But the nodes which don't have counter process must know Pid to reach it and nodes must be connected already each others.
2. I know erlang nodes can easily connect each other But I need auto discovery and connection mechanism Otherwise connection each other manually not feasible.(try to connect each node Node.ping(1),Node.ping(2) ...)
3. Which node should hold Counter process and how it should be started ? If all nodes start counter process and register global, connection each other cause conflict therefore cannot connect.

* To handle first challenge, I have decided use erlang global name registration facility that provides distributed name registry. Process registry only support local therefore ı had removed it.

* To handle second challenge, I have implemented scheduled jobs that read other nodes info from config and try discovery and connect nodes in  interval.This process starts before phoenix server started.

* To handle third challenge. I have decided counter process should not start auto when server is started Therefore I have changed it's supervisor to dynamic. When first request come, The Node try to find counter process in global registry. if not exist, it creates and register globally.

### Assessment
Yeap I know this is not perfect and autonomous solution because it depends many things.
There are many alternative solutions for challenges which is I have met. But with other exercises such as Distributed Morse Decoder and Queen Attack I have plan to solve different ways them if I find time :)
