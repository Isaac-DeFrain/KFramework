# K Configuration for Message Passing with Join

I recently added several new cells to the grho configuration to capture the semantics of the *join operator* (several listens in one receive). The goal was to keep the configuration cell minimalist, but it seems like these recently added cells are required for joins. The desired semantics of the join operator involves matching an arbitrary number of sends and listens before a comm event occurs and these sends can be matched by any listen in any receive in the tuplespace.

Here is how the configuration currently looks:
```
    <T>
      <threads>
        <thread*>
          <k/>
        </thread>
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
      <reaction>
        <who/> <what/> <where/> <rid/> <react/> <forg/>
      </reaction>
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
  * `<chan/>`: containing the channel on which the listen awaits a message
  * `<vars/>`: containing the list of patterns to bind with the received messages
  * `<num/>`: containing the number of patterns the listen listens for
  * `<lid/>`: containing the unique id of the listen
  * `<msid/>`: containing the id of a matched send (if there is one)

## Reaction: `<reaction/>`
The `reaction` cell exists to ensure proper resource management. It contains the *six* sub-cells:
* `<who/>`: containing the continuation of the receive to be substituted 
* `<what/>`: containing the message(s) of the send to substitute into the continuation
* `<where/>`: containing the pattern(s) which the message(s) will be substituted for in the continuation
* `<rid/>`: containing the id of the receive being processed
* `<react/>`: containing the state of the reaction (described below)
* `<forg/>`: containing the set of send ids consumed in the comm event and thus to be forgotten by any matching listens

## How the definition works
There are *three* "phases" during the execution of a program: load, matching, and collection.

The first thing that happens when a Rholang program is executed in this implementation is all `new`-bound variables are substituted for an unforgeable integer. Then, we move to what I have been calling the "load" phase. In the load phase, all processes involved in the top-level par are put into their own concurrently executing computation cell. Sends and receives are then moved to the tuplespace into a `send` or `rec` cell, respectively. Sends and single-listen receives are processed into their cell counterparts in a straightforward manner. Several-listen receives are handled differently.

First, we generate a unique id for a several-listen receive, wrap it with this id, and generate a `rec` cell containing this id, the number of listens in the receive, the continuation, and an initial match count of 0. Then, the id wrapped receive continues to process each listen into its own `listen` cell within the `rec` cell with all the corresponding info. Once we have processed all but the last listen in the receive, we finalize the `rec` cell creation by dissolving the id wrapped receive from it's `k` cell and adding this final listen to the same `rec` cell. This process ensures that all listens in a receive will be put into the correct `rec` cell. Once all sends and receives have been put into the tuplespace, the load phase concludes.

After the load phase, the program enters the "matching" phase. In the matching phase, each listen in each receive searches for a matching send. A send and a listen match when they refer to the same channel and number of messages/patterns. E.g. the send `chan!(1,2,3)` and the listen `a,b,c <= chan` (say from the receive `for( d <= chan ; a,b,c <= chan ){ P(a,b,c,d) }`) match because they both refer to the same channel `chan` and same number of processes/names (3 in this case), but `chan!(1,2,3)` does not match the listen `d <= chan`. This phase continues until (at least) one receive has matched all its listens with the available sends. Matching is a source of nondeterminism.

When a listen matches a send, four things happen simultaneously:
1. the match count of the receive containing the listen is increased by 1
2. the matching send id is added to the receive's `nomo` set (so this is the only listen in this receive matching this send; listens in other receives may also match this send, listens compete to match sends in some respect)
3. the matching send id is recorded as a "matched send id" in the listen's `msid` cell (a listen can only have one matched send)
4. the send records the matched listen's id in its `mlid` set (each send records all the matching listen ids so that if the send is consumed, these listens can forget this send id and try to match another send in the tuplespace)

Considering that all matching happens concurrently, it may be the case that more than one receive moves to a "matched" state at the same time. To ensure that comm events are atomic actions, we only allow one receive to comm at a time; however, we are agnostic as to which receive will comm so either one may go first. This is another source of nondeterminism.

To begin processing a comm, one fully matched receive moves to a "collection" state. Once one receive is in a collection state, it initializes the `reaction` cell with its id and continuation; it also sets the reaction count to 0 and puts the `reaction` cell in a "collect" state. Once the `reaction` cell is in a "collect" state, it pulls the info from each listen in the receive into the `reaction` cell. If the listen is consumable, its `listen` cell is dissolved from the `rec` cell. If the send it matches is consumable, it is dissolved and the set of matching listen ids is moved to the `forg` cell within the `reaction` cell. The reaction cell immediately moves to a "forget" state in which the send id is forgotten by each of the listens that matched it. E.g. if we have the receives `for( a <! x ){ P(a) }` and `for( a <- x ){ Q(a) }` in the tuplespace whose listens both match the consumable send `x!(x!(1))`, one of these matched receives, say `for( a <- x ){ Q(a) }`, moves to a collection state. During this comm event, the send is consumed by this receive, and hence may not be consumed again. The send is deleted from the tuplespace and the other receive, `for( a <! x ){ P(a) }`, forgets about the send and moves back to a matching state to look for a matching send.

During this collection phase, all necessary substitutions are carried out and all 

