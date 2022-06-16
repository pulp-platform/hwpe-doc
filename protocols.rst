
************************
HWPE Interface Protocols
************************

HWPE-Stream protocol
====================

The HWPE-Stream protocol is a simple protocol designed to move data
between the various sub-components of an HWPE. As HWPEs are memory-based
accelerators, streams are typically generated and consumed internally
within the accelerator between fully synchronous devices.
HWPE-Stream can cross between two clock domains using dual-clock FIFOs;
handshakes still have to happen in a fully synchronous way.
HWPE-Stream streams are directional, flowing from a *source* to a *sink*
direction, using a two signal *handshake* and carrying a data *payload*.
:numref:`hwpe_stream_source_sink` and :numref:`hwpe_stream_signals` report
the signals used by the HWPE-Stream protocol.

.. _hwpe_stream_source_sink:
.. figure:: img/hwpe_stream_source_sink.*
  :figwidth: 60%
  :width: 60%
  :align: center

  Data flow of the HWPE-Stream protocol. Red signals carry the *handshake*,
  blue ones the *payload*.

.. _hwpe_stream_signals:
.. table:: HWPE-Stream signals.

  +-----------------+-----------------+-----------------+-----------------+
  | **Signal**      | **Size**        | **Description** | **Direction**   |
  +-----------------+-----------------+-----------------+-----------------+
  | *data*          | Multiple of 8   | The data        | from *source*   |
  |                 | bits            | payload         | to *sink*       |
  |                 |                 | transported by  |                 |
  |                 |                 | the stream.     |                 |
  +-----------------+-----------------+-----------------+-----------------+
  | *strb*          | size(*data*)/8  | Optional.       | from *source*   |
  |                 |                 | Indicates valid | to *sink*       |
  |                 |                 | bytes in the    |                 |
  |                 |                 | data payload    |                 |
  |                 |                 | (1=valid).      |                 |
  +-----------------+-----------------+-----------------+-----------------+
  | *valid*         | 1 bit           | Handshake valid | from *source*   |
  |                 |                 | signal          | to *sink*       |
  |                 |                 | (1=asserted).   |                 |
  +-----------------+-----------------+-----------------+-----------------+
  | *ready*         | 1 bit           | Handshake ready | from *sink*     |
  |                 |                 | signal          | to *source*     |
  |                 |                 | (1=asserted).   |                 |
  +-----------------+-----------------+-----------------+-----------------+

The handshake signals *valid* and *ready* are used to validate
transactions between sources and sinks. Transactions are subject to the
following rules:

1. **A handshake occurs in the cycle when both** *valid* **and** *ready*
   **are asserted**. The handshake is the "atomic" event after which the
   current payload is considered consumed by the consumer at the sink
   side of the HWPE-Stream interface.

2. *data* **and** *strb* **can change their value either a) when** *valid*
   **is deasserted, or b) in the cycle following a handshake, even if**
   *valid* **remains asserted**. In other words, valid data payloads must
   stay on the interface until a valid handshake has occurred.

3. **The assertion of** *valid* **(transition 0 to 1) cannot depend**
   **combinationally on the state of** *ready*.
   On the other hand, the assertion of *ready* (transition 0 to 1) can
   depend combinationally on the state of *valid*. This rule, which is
   modeled around the similar behavior used by TCDM memories (see below)
   is meant to avoid any deadlock in ping-pong logic.

4. **The deassertion of** *valid* **(transition 1 to 0) can happen only**
   **in the cycle after a valid handshake**. In other words, valid data
   produced by a source must be correctly consumed before *valid*
   is deasserted.

.. .. _wavedrom_hwpe_stream_r2_ok:
.. .. wavedrom:: wavedrom/hwpe_stream_r2_ok.json
..   :width: 50 %
..   :caption: HWPE-Stream handshake satisfying rule 2.

.. _wavedrom_hwpe_stream:
.. wavedrom:: wavedrom/hwpe_stream.json
  :width: 100 %
  :caption: Example of a HWPE-Stream with an 8-bit data stream. Valid
            handshakes happen in cycles 3,4,6, and 8.

.. _wavedrom_hwpe_stream_r2_no:
.. wavedrom:: wavedrom/hwpe_stream_r2_no.json
  :width: 50 %
  :caption: Incorrect HWPE-Stream handshake, not satisfying rule 2.

.. _wavedrom_hwpe_stream_r4_no:
.. wavedrom:: wavedrom/hwpe_stream_r4_no.json
  :width: 50 %
  :caption: Incorrect HWPE-Stream handshake, not satisfying rule 4.

:numref:`wavedrom_hwpe_stream` shows several correct handshakes on
a HWPE-Stream, while :numref:`wavedrom_hwpe_stream_r2_no` and
:numref:`wavedrom_hwpe_stream_r4_no` show two examples of incorrect
transactions. Both behaviors are checked by means of asserts in the
reference SystemVerilog code for HWPE-Stream interfaces.
Rule 3 cannot be checked by means of asserts; it is up to the designer
to avoid *valid* to *ready* combinational dependencies that could
result in combinational loops, since the value of *ready* is assumed
to be combinationally dependent from *valid*.

The only side channel that can be included in an HWPE-Stream is *strb*,
which is optionally used to signal which bytes of the *data* payload
contain meaningful data. HWPE-Stream streams in which *strb* is absent
are assumed to have only valid bytes in their *data* payload. We refer
HWPE-Stream streams with *strb* as *strobed streams*.

HWPE-Mem and HCI-Core protocols
===============================

HWPE-Mem
--------

HWPEs are connected to external L1/L2 shared-memory by means of a simple
memory protocol, using a request/grant handshake. The protocol used is
called HWPE Memory (*HWPE-Mem*) protocol, and it is essentially similar
to the protocol used by cores and DMAs operating on memories in standard
PULP clusters.
This document focuses on the specific signal names used within HWPEs
and in the reference implementation of HWPE-Stream IPs.
It supports neither multiple outstanding transactions nor bursts, as
HWPEs using this protocol are assumed to be closely coupled to memories.
It uses a two signal *handshake* and carries two phases, a *request* and
a *response*.

The HWPE-Mem protocol is used to connect a *master* to a *slave*.
:numref:`hwpe_tcdm_master_slave` and :numref:`hwpe_tcdm_signals` report
the signals used by the HWPE-Mem protocol.

.. _hwpe_tcdm_master_slave:
.. figure:: img/hwpe_tcdm_master_slave.*
  :figwidth: 60%
  :width: 60%
  :align: center

  Data flow of the HWPE-Mem protocol. Red signals carry the
  *handshake*; blue signals the *request* phase; green signals the
  *response* phase.

.. _hwpe_tcdm_signals:
.. table:: HWPE-Mem signals.

  +------------+----------+----------------------------------------+---------------------+
  | **Signal** | **Size** | **Description**                        | **Direction**       |
  +------------+----------+----------------------------------------+---------------------+
  | *req*      | 1 bit    | Handshake request signal (1=asserted). | *master* to *slave* |
  +------------+----------+----------------------------------------+---------------------+
  | *gnt*      | 1 bit    | Handshake grant signal (1=asserted).   | *slave* to *master* |
  +------------+----------+----------------------------------------+---------------------+
  | *add*      | 32 bit   | Word-aligned memory address.           | *master* to *slave* |
  +------------+----------+----------------------------------------+---------------------+
  | *wen*      | 1 bit    | Write enable signal (1=read, 0=write). | *master* to *slave* |
  +------------+----------+----------------------------------------+---------------------+
  | *be*       | 4 bit    | Byte enable signal (1=valid byte).     | *master* to *slave* |
  +------------+----------+----------------------------------------+---------------------+
  | *data*     | 32 bit   | Data word to be stored.                | *master* to *slave* |
  +------------+----------+----------------------------------------+---------------------+
  | *r_data*   | 32 bit   | Loaded data word.                      | *slave* to *master* |
  +------------+----------+----------------------------------------+---------------------+
  | *r_valid*  | 1 bit    | Valid loaded data word (1=asserted).   | *slave* to *master* |
  +------------+----------+----------------------------------------+---------------------+

The handshake signals *req* and *gnt* are used to validate transactions
between masters and slaves. Transactions are subject to the following
rules:

1. **A valid handshake occurs in the cycle when both** *req* **and** *gnt*
   **are asserted**. This is true for both write and read transactions.

2. *r_valid* **must be asserted the cycle after a valid read handshake;**
   *r_data* **must be valid on this cycle**. This is due to
   the tightly-coupled nature of memories; if the memory cannot
   respond in one cycle, it must delay granting the transaction.

3. **The assertion of** *req* **(transition 0 to 1) cannot depend**
   **combinationally on the state of** *gnt*. On the other hand,
   the assertion of *gnt* (transition 0 to 1) can depend combinationally
   on the state of *req* (and typically it does). This rule avoids
   deadlocks in ping-pong logic.

The semantics of the *r_valid* signal are not well defined with respect
to the usual TCDM protocol. In PULP clusters, *r_valid* will be asserted
also after write transactions, not only in reads. However, the HWPE-Mem
protocol and the IPs in this repository should not make assumptions
on the *r_valid* in write transactions.

HWPE-MemDecoupled
-----------------

The HWPE-Mem protocol can be used to directly connect an accelerator to the
shared memory of a PULP-based system. However, transactions using this protocol
are inherently latency sensitive. HWPE-Mem rule 2 embodies this: an operation
is complete only when its response has arrived. This means that HWPE-Mem
streams, including load and store transactions, cannot be enqueued in
a FIFO queue.
To overcome this limitation, a variant of the HWPE-Mem protocol is
HWPE-MemDecoupled. This protocol uses the same interface as HWPE-Mem but
lifts rule 2 and adds a new rule 4. Transactions are thus following the
following rules:

1. **A valid handshake occurs in the cycle when both** *req* **and** *gnt*
   **are asserted**. This is true for both write and read transactions.

3. **The assertion of** *req* **(transition 0 to 1) cannot depend**
   **combinationally on the state of** *gnt*. On the other hand,
   the assertion of *gnt* (transition 0 to 1) can depend combinationally
   on the state of *req* (and typically it does). This rule avoids
   deadlocks in ping-pong logic.

4. **The stream of transactions includes only reads (** *wen* **=1) or**
   **only writes (** *wen* **=0)**. Mixing reads and writes in the stream
   is not allowed.

HWPE-MemDecoupled transactions are insensitive to latency and their
*request* and *response* phases can be treated similarly to separate
HWPE-Stream streams.
Once two or more HWPE-MemDecoupled transactions are mixed, the mixed
interface has to be treated as a HWPE-Mem protocol (i.e. it is sensitive
to latency).

HCI-Core
--------

HCI-Core (Heterogeneous Cluster Interconnect -- Core) is a protocol designed
as a lighteweight extension of HWPE-Mem better suited for the needs of
accelerators, and specifically of cluster-coupled HWPEs.
This document focuses on the specific signal names used within HWPEs
and in the reference implementation of HCI IPs.
HCI-Core does not support bursts, but it supports in-order multiple
outstanding transactions in a similar fashion to HWPE-MemDecoupled.
Differently from HWPE-Mem, HCI-Core uses a two signal *handshake* but also
includes an `lrdy` signal to support load backpressure on the response phase.
HCI-Core carries two phases, a *request* and a *response*.
HCI-Core signals have parametric width; :numref:`hci_parameters` reports the
parameters used by the HCI IPs; while :numref:`hci_signals` reports the signals
used by the HCI-Core protocol.

.. _hci_core_parameters:
.. table:: HCI-Core parameters.

  +---------------+-------------------------------------------------+-------------+---------------------+
  | **Parameter** | **Description**                                 | **Default** | **Range**           |
  +---------------+-------------------------------------------------+-------------+---------------------+
  | *DW*          | Data width in bits                              | 32          | mult. of *BW*, *WW* |
  +---------------+-------------------------------------------------+-------------+---------------------+
  | *AW*          | Address width in bits                           | 32          | 1-32                |
  +---------------+-------------------------------------------------+-------------+---------------------+
  | *BW*          | Width of an individually strobed "byte" in bits | 8           | 1-32                |
  +---------------+-------------------------------------------------+-------------+---------------------+
  | *WW*          | Width of a memory bank ("word") in bits         | 32          | mult. of *BW*       |
  +---------------+-------------------------------------------------+-------------+---------------------+
  | *OW*          | Intra-bank offset width                         | 32          | 1-32                |
  +---------------+-------------------------------------------------+-------------+---------------------+
  | *UW*          | User-defined      width                         | 0           | 0-any               |
  +---------------+-------------------------------------------------+-------------+---------------------+

.. _hci_core_signals:
.. table:: HCI-Core signals.

  +------------+----------------------+-------------+-----------------------------------------------------------------------+---------------------+
  | **Signal** | **Size**             | **Phase**   | **Description**                                                       | **Direction**       |
  +------------+----------------------+-------------+-----------------------------------------------------------------------+---------------------+
  | *req*      | 1 bit                | Request HS  | Request valid (1=asserted).                                           | *master* to *slave* |
  +------------+----------------------+-------------+-----------------------------------------------------------------------+---------------------+
  | *gnt*      | 1 bit                | Request HS  | Request granted (1=asserted).                                         | *slave* to *master* |
  +------------+----------------------+-------------+-----------------------------------------------------------------------+---------------------+
  | *r_valid*  | 1 bit                | Response HS | Response valid (1=asserted). Mandatory for load, optional for stores. | *slave* to *master* |
  +------------+----------------------+-------------+-----------------------------------------------------------------------+---------------------+
  | *lrdy*     | 1 bit                | Response HS | Response load ready (1=asserted).                                     | *master* to *slave* |
  +------------+----------------------+-------------+-----------------------------------------------------------------------+---------------------+
  | *add*      | *AW* bit             | Request     | Word-aligned memory address.                                          | *master* to *slave* |
  +------------+----------------------+-------------+-----------------------------------------------------------------------+---------------------+
  | *wen*      | 1 bit                | Request     | Write enable signal (1=read, 0=write).                                | *master* to *slave* |
  +------------+----------------------+-------------+-----------------------------------------------------------------------+---------------------+
  | *be*       | *DW/BW* bit          | Request     | Byte enable signal (1=valid byte).                                    | *master* to *slave* |
  +------------+----------------------+-------------+-----------------------------------------------------------------------+---------------------+
  | *boffs*    | *DW/WW* x *OW* bit   | Request     | Intra-bank offset.                                                    | *master* to *slave* |
  +------------+----------------------+-------------+-----------------------------------------------------------------------+---------------------+
  | *data*     | *DW* bit             | Request     | Data word to be stored.                                               | *master* to *slave* |
  +------------+----------------------+-------------+-----------------------------------------------------------------------+---------------------+
  | *user*     | *UW* bit             | Request     | User-defined.                                                         | *master* to *slave* |
  +------------+----------------------+-------------+-----------------------------------------------------------------------+---------------------+
  | *r_data*   | 32 bit               | Response    | Loaded data word.                                                     | *slave* to *master* |
  +------------+----------------------+-------------+-----------------------------------------------------------------------+---------------------+
  | *r_opc*    | 1 bit                | Response    | Error code response.                                                  | *slave* to *master* |
  +------------+----------------------+-------------+-----------------------------------------------------------------------+---------------------+
  | *r_user*   | *UW* bit             | Request     | User-defined.                                                         | *slave* to *master* |
  +------------+----------------------+-------------+-----------------------------------------------------------------------+---------------------+
  
The two phases of HCI-Core transactions can be treated as two separate channels,
so HCI-Core transactions can be latency insensitive and support multiple
in-order outstanding transactions (i.e., pipeline transactions).
Request and response phases are organized to be treated like HWPE-Stream streams.
:numref:`hci_core_request_rules` and :numref:`hci_core_response_rules` detail
the rules that have to be followed for a valid transaction.

.. _hci_core_request_rules:
.. table:: HCI-Core Request phase rules.

  +--------------+----------------------------------------------------------------+
  | **Rule**     | **Description**                                                |
  +----------------+--------------------------------------------------------------+
  | RQ-1         | A valid handshake occurs in the cycle when both *req* and      |
  | *HANDSHAKE*  | *gnt* are asserted, for both write and read transactions.      |
  |              | All request phase signals are sampled on handshake cycles.     |
  +--------------+----------------------------------------------------------------+
  | RQ-2         | The assertion of *req* (transition 0 to 1) cannot depend       |
  | *NODEADLOCK* | combinationally on the state of *gnt*. On the other hand,      |
  |              | the assertion of *gnt* (transition 0 to 1) can depend          |
  |              | combinationally on the state of *req*. This rule avoids        |
  |              | deadlocks in ping-pong logic.                                  |
  +--------------+----------------------------------------------------------------+
  | RQ-3         | Request phase signals can change their value either in the     |
  | *STABILITY*  | cycle following a handshake, regardless if *req* is            |
  |              | deasserted or stays asserted.                                  |
  +--------------+----------------------------------------------------------------+
  | RQ-OPT-3     | (Optional) Requests cannot be retired after *req* is asserted. |
  | *NORETIRE*   | HCI accelerators satisfy this indication, but not all masters  |
  |              | on HCI interconnects might be fully compliant.                 |
  +--------------+----------------------------------------------------------------+

.. _hci_core_response_rules:
.. table:: HCI-Core Response phase rules.

  +--------------+---------------------------------------------------------------+
  | **Rule**     | **Description**                                               |
  +----------------+-------------------------------------------------------------+
  | RSP-1        | For read transactions, a valid handshake occurs in the cycle  |
  | *HANDSHAKE*  | when both *r_valid* and *lrdy* are asserted.                  |
  |              | All response phase signals are sampled on handshake cycles.   |
  +--------------+---------------------------------------------------------------+
  | RSP-2        | The assertion of *r_valid* (transition 0 to 1) cannot depend  |
  | *NODEADLOCK* | combinationally on the state of *lrdy*. On the other hand,    |
  |              | the assertion of *lrdy* (transition 0 to 1) can depend        |
  |              | combinationally on the state of *r_valid*. This rule avoids   |
  |              | deadlocks in ping-pong logic.                                 |
  +--------------+---------------------------------------------------------------+
  | RSP-3        | Response phase signals can change their value either in the   |
  | *STABILITY*  | cycle following a handshake, regardless if *r_valid* is       |
  |              | deasserted or stays asserted.                                 |
  +--------------+---------------------------------------------------------------+
  | RSP-4        | Response phase signals must follow the same ordering of the   |
  | *ORDERING*   | requests.                                                     |
  +--------------+---------------------------------------------------------------+

.. _wavedrom_hci_core:
.. wavedrom:: wavedrom/hci_core.json
   :width: 100 %
   :caption: Example of a HCI-Core transaction with *DW*=16-bit.

:numref:`wavedrom_hci_core` shows an example of a correct HCI-Core transaction.

Exchanging data between HWPE-Mem and HWPE-Stream
------------------------------------------------

As HWPEs ultimately consume and produce data to the external shared
memory using one or more ports exposing TCDM interfaces, converting data
between HWPE-Mem and HWPE-Stream (i.e., exchanging data between the
memory-based and the stream-based worlds) is one of the main tasks to be
accomplished in the design of an accelerator. The HWPE-Stream and HWPE-Mem
protocols are similar by design, which makes the handling of handshakes
signficantly easier.
The following applies to HWPE-Mem, HWPE-MemDecoupled, and HCI-Core in a similar
manner.

Three objectives have to be met:

-  HWPE-Stream has no notion of address: to produce a stream out of HWPE-Mem
   loads, or consume a stream in a series of HWPE-Mem stores, it is
   necessary to generate addresses according to some rule.

-  HWPE-Stream streams can be longer than 32 bits; it is necessary to
   generate them from / split them into multiple TCDM loads/stores.

-  HWPE-Mem addresses may be misaligned with respect to word
   boundaries, in which case two TCDM loads/stores are necessary to
   transact a single 32-bit word and strobes have to be also aligned.

In the current version of the HWPE specifications, we address these
issues by providing a set of modules which can incrementally be used to
solve each of the problems above. This are referred to in a later section.

.. _tcdm_stream_source:
.. figure:: img/tcdm_stream_source.*
  :figwidth: 100%
  :width: 100%
  :align: center

  Example of data exchange between a series of HWPE-Mem loads and a
  HWPE-Stream. Four data packets have to be produced at the sink end
  of the stream; since data is not well aligned in memory, this results
  in five loads on the HWPE-Mem interface, which are then transformed
  in a strobed HWPE-Stream. The stream is then realigned so that the
  correct four elements are available.

.. _tcdm_stream_sink:
.. figure:: img/tcdm_stream_sink.*
  :figwidth: 100%
  :width: 100%
  :align: center

  Example of data exchange between a HWPE-Stream and a series of HWPE-Mem
  stores. Four data packets have to be consumed at the source end
  of the stream; since data is not well aligned in memory, this results
  in a strobed HWPE-Stream with five packets, the first and last of which
  contain also null data. The strobed stream is then converted in a set of
  five HWPE-Mem store transactions.

:numref:`tcdm_stream_source`, :numref:`tcdm_stream_sink` show two
examples of transactions going (respectively) from a series of loads
on the HWPE-Mem interface to internal HWPE-Streams and from an internal
HWPE-Stream to a series of stores on HWPE-Mem. The example focuses on
the realignment behavior.

HWPE-Periph protocol
====================

To enable control, HWPEs typically expose a slave port to the
peripheral system interconnect. The slave port follows an extension of
the HWPE-Mem protocol which we call HWPE-Periph in this document.
The HWPE-Periph protocol is essentially the same one exposed by most
peripherals in a PULP system and used by the core to communicate with them.

.. _hwpe_periph_signals:
.. table:: HWPE-Periph signals.

  +-----------------+-----------------+-----------------+---------------------+
  | **Signal**      | **Size**        | **Description** | **Direction**       |
  +-----------------+-----------------+-----------------+---------------------+
  | *req*           | 1 bit           | Handshake       | *master* to *slave* |
  |                 |                 | request signal  |                     |
  |                 |                 | (1=asserted).   |                     |
  +-----------------+-----------------+-----------------+---------------------+
  | *gnt*           | 1 bit           | Handshake grant | *slave* to *master* |
  |                 |                 | signal          |                     |
  |                 |                 | (1=asserted).   |                     |
  +-----------------+-----------------+-----------------+---------------------+
  | *add*           | 32 bit          | Word-aligned    | *master* to *slave* |
  |                 |                 | memory address. |                     |
  +-----------------+-----------------+-----------------+---------------------+
  | *wen*           | 1 bit           | Write enable    | *master* to *slave* |
  |                 |                 | signal (1=read, |                     |
  |                 |                 | 0=write).       |                     |
  +-----------------+-----------------+-----------------+---------------------+
  | *be*            | 4 bit           | Byte enable     | *master* to *slave* |
  |                 |                 | signal (1=valid |                     |
  |                 |                 | byte).          |                     |
  +-----------------+-----------------+-----------------+---------------------+
  | *data*          | 32 bit          | Data word to be | *master* to *slave* |
  |                 |                 | stored.         |                     |
  +-----------------+-----------------+-----------------+---------------------+
  | *id*            | ID_WIDTH bits   | ID used to      | *master* to *slave* |
  |                 |                 | identify the    |                     |
  |                 |                 | master          |                     |
  |                 |                 | (request).      |                     |
  +-----------------+-----------------+-----------------+---------------------+
  | *r_data*        | 32 bit          | Loaded data     | *slave* to *master* |
  |                 |                 | word.           |                     |
  +-----------------+-----------------+-----------------+---------------------+
  | *r_valid*       | 1 bit           | Valid loaded    | *slave* to *master* |
  |                 |                 | data word       |                     |
  |                 |                 | (1=asserted).   |                     |
  +-----------------+-----------------+-----------------+---------------------+
  | *r_id*          | ID_WIDTH bits   | ID used to      | *slave* to *master* |
  |                 |                 | identify the    |                     |
  |                 |                 | master (reply). |                     |
  +-----------------+-----------------+-----------------+---------------------+

The HWPE-Periph protocol is distinguished by the HWPE-Mem protocol by the *id*
and *r_id* side channels. These are used in load operations issued
through a PERIPH interface: the *id* identifies the master during the
request phase, is buffered by the slave peripherals and accompanies the
response phase as *r_id*. In this way, multiple masters can distinguish
which traffic is related to themselves.
For the rest of the purposes related with HWPEs, HWPE-Periph and HWPE-Mem work
in the same way. In particular, similarly to HWPE-Mem, PULP clusters will expect
*r_valid* to be asserted after write transactions. This is enforced also in
HWPE IPs.

.. -  The **hwpe_stream_addressgen** module is responsible of generating
..    addresses according to a pattern of 3D blocks characterized by width,
..    height and depth.

.. -  The **hwpe_stream_merge** and **hwpe_stream_split** modules can be
..    used to merge/split HWPE-Stream streams. In this way, on the module
..    boundary 32-bit streams can be converted in TCDM accesses.

.. -  The **hwpe_stream_source_realign** and **hwpe_stream_sink_realign**
..    modules can be used to transform a strobed stream into unstrobed ones
..    and to transform unstrobed streams into strobed ones. In this way,
..    misaligned TCDM accesses can be already transformed in streams with a
..    strobe to indicate what data is meaningful.
