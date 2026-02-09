### op_code Stability Requirement ### 

op_code must be stable before and during the rising clock edge where valid_in is asserted.

op_code may change freely only when valid_in == 0.

Changing op_code while valid_in == 1 may cause undefined or incorrect behavior.

###  Single-Cycle Transaction ### 

Each operation is transferred using a single-cycle pulse of valid_in.

valid_in is asserted for exactly one clock cycle per operation.

Each rising edge with valid_in = 1 corresponds to one independent command.

### Back-to-Back Transactions ### 

A minimum of two idle clock cycles (valid_in = 0) is inserted between transactions.

This spacing allows internal processing or pipeline clearing (if applicable).

Back-to-back valid_in assertions are not allowed unless explicitly supported by the design.
