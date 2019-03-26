# K Configuration for Message Passing with Join

I recently added several new cells to the grho configuration to capture the semantics of the *join operator*. The goal was to keep the configuration cell minimalist, but it seems like these recently added cells are required for joins. The desired semantics of the join operator involves matching an arbitrary number of sends and listens before a comm event occurs and these sends can be matched by any listen in any receive in the tuplespace.

Here is how the configuration currently looks:
```
    <T>
      <threads>
        <thread*> <k/> </thread>
      </threads>
      <tuplespace>
        <sends>
          <send*>
            <schan/> <msg/> <tuple/> <stype/> <sid/>
          </send>
        </sends>
        <receives>
          <rec*>
            <id/> <length/> <state> <cont/> <state/> <type/> <nomo/>
            <listens>
              <listen*>
                <chan/> <vars/> <num/> <lid/> <msid/>
              </listen>
            </listens>
          </rec> 
        </receives>
      </tuplespace>
      <reaction> <who/> <what/> <where/> <rid/> <react/> <forg/> </reaction>
    </T>
```

Let me explain the idea behind each of the components in this configuration and definition. 

## Computation Threads: `<threads/>, <thread/>, <k/>`
The `threads` cell simply wraps all the individual `thread` cells. There can be any number of `thread` cells 0, 1, 2, ... Each `thread` cell contains one `k` cell, in which all computations are carried out. Since Rholang is a concurrent programming language in which `P|Q` denotes the the processes `P` and `Q` executing concurrently, in general, we need several concurrently executing computation cells. Thus we make it so that the Rholang term `P|Q` rewrites as the two thread cells `<thread> <k> P </k> </thread>` and `<thread> <k> Q </k> </thread>`. Now K will execute these processes concurrently. Ground terms stay in their `thread` cell, but sends and receives are further processed into `send` and `rec` cells in the tuplespace, so we can model the nondeterministic reductions native to Rholang.

## Tuplespace: `<tuplespace/>`
The `tuplespace` cell simply houses all of the `send` and `rec` cells.

### Sends: `<sends/>, <send/>`
The `sends` cell contains the bag of `send` cells. There can be 0 or more `send` cells. Each `send` cell contains the *five* sub-cells:
* `<schan/>`: containing the channel on which the send sends its message
* `<msg/>`: containing the tuple of messages sent by the send
* `<tuple/>`: containing the number of messages being sent, i.e. the length of the message tuple
* `<stype/>`: containing the type of the send, i.e. 0 for consumable, 1 for persistent
* `<sid/>`: containing the unique id of the send

### Receives: `<receives/>, <rec/>`
The `receives` cell contains the bag of `rec` cells. There can be 0 or more `rec` cells. Each `rec` cell contains several sub-cells:
* `<id/>`: containing the unique id of the receive
* `<length/>`: containing the number of listens in the receive
* `<cont/>`: containing the continuation of the receive
* `<state/>`: containing the state of the receive, i.e. matching, matched, collection
* `<type/>`: containing the type of the receive, i.e. 0 for linear, 1 for persistent, and 2 for peek
* `<nomo/>`: containing the set of send id which have been matched by one of the listens in the receive
* `<listens/>`: containing the bag of `listen` cells. Each `listen` cell contains the *five* sub-cells:
  * `<chan/>`: contains the channel on which the listen awaits a message
  * `<vars/>`: contains the list of patterns to bind with the received messages
  * `<num/>`: contains the number of patterns the listen listens for
  * `<lid/>`: contains the unique id of the listen
  * `<msid/>`: contains the id of a matched send (if there is one)

## Reaction: `<reaction/>`
The `reaction` cell exists to ensure proper resource management. 

When a listen matches a send, four things happen simultaneously:
1. the match count of the receive containing the listen is increased by 1
2. the matching send id is added to the receive's `nomo` set (so this is the only listen in this receive matching this send; listens in other receives may also match this send, listens compete to match sends in some respect)
3. the matching send id is recorded as a "matched send id" in the listen's `msid` cell (a listen can only have one matched send)
4. the send records the matched listen's id in its `mlid` set (each send records all the matching listen ids so that if the send is consumed, these listens can forget this send id and try to match another send in the tuplespace)