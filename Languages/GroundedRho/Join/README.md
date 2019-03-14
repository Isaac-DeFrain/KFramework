# K Configuration for Joins

I recently added several new cells to the grho configuration to capture the semantics of *the join operator*. The goal was to keep the configuration cell minimalist, but it seems like these recently added cells are required for joins. The desired semantics of the join operator involves matching an arbitrary number of sends and listens before a comm event occurs and these sends can be matched by any listen in any receive in the tuplespace.

Here is how the configuration currently looks.
```
    <T>
      <threads>
        <thread*> <k/> </thread>
      </threads>
      <tuplespace>
        <sends>
          <send*> <schan/> <msg/> <tuple/> <stype/> <sid/> </send>
        </sends>
        <receives>
          <rec*> <id/> <length/> <cont/>
            <listens>
              <listen*> <chan/> <vars/> <num/> <type/> </listen>
            </listens>
            <match/> <nono/>
            <bindstore>
              <pair*> <bind/> <bid/> </pair>
            </bindstore>
            <sendstore>
              <vsend*> <vchan> <vmsg> <vlen> <vtype> <vid> </vsend>
            </sendstore> 
          </rec> 
        </receives>
      </tuplespace>
      <reaction> <who/> <what/> <where/> <rid/> <react/> </reaction>
    </T>
```

Let me explain the thinking behind each of the components in this configuration/definition. 

## Top cell: `<T/>`
This is always included and simply wraps all the other cells.

## Threads, Thread, and k cells: `<threads/>, <thread/>, <k/>`
The threads cell simply wraps all the thread cells. There can be any number of thread cell 0, 1, 2, ... Each thread cell contains one computation cell (k), in which all computations in K are executed. Since Rholang is a concurrent programming language in which `P|Q` denotes the the processes `P` and `Q` executing concurrently, we need several concurrently executing computation cells in general. Thus we make it so that the Rholang term `P|Q` rewrites as the two thread cells `<thread> <k> P </k> </thread>` and `<thread> <k> Q </k> </thread>`.

## Tuplespace cell: `<tuplespace/>`

### Sends and Send cells: `<sends/>, <send/>`

### Receives and Rec cells: `<receives/>, <rec/>`

## Reaction cell: `<reaction/>`


When a listen matches a send, four things happen simultaneously:
1. the match count is increased
2. the send id is added to nono set (if the send is consumable)
3. the listen is moved to the bindstore (so it doesn't match again)
4. the send is moved to the sendstore (so it can be consumed from the tuplspace when a comm occurs)