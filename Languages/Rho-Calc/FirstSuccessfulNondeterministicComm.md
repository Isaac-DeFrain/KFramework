# Terminal output: first successful comm transition

```
  $ kompile rho.k --backend java --transition "comm"

  $ krun tests/comm_multiple_id.rho --search-final

  Result ==K 
  <T>
    <activity>
      <thread>
        <k>
          * z
        </k>
      </thread>
    </activity>
    <tuplespace>
      <sends>
        <send>
          <schan>
            x
          </schan>
          <msg>
            a
          </msg>
        </send>
      </sends>
      <recs>
        <rec>
          <rchan>
            a
          </rchan>
          <bind>
            u
          </bind>
          <cont>
            * u
          </cont>
        </rec>
      </recs>
    </tuplespace>
  </T>
  #Or
  Result ==K 
  <T>
    <activity>
      <thread>
        <k>
          * z
        </k>
      </thread>
    </activity>
    <tuplespace>
      <sends>
        <send>
          <schan>
            x
          </schan>
          <msg>
            b
          </msg>
        </send>
      </sends>
      <recs>
        <rec>
          <rchan>
            b
          </rchan>
          <bind>
            v
          </bind>
          <cont>
            * v
          </cont>
        </rec>
      </recs>
    </tuplespace>
  </T>
```

