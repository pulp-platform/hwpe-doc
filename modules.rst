********************************************
Hardware Processing Engines: Concept and IPs
********************************************

*Hardware Processing Engines* (HWPEs) are special-purpose,
memory-coupled accelerators that can be inserted in the SoC or cluster
of a PULP system to amplify its performance and energy efficiency in
particular tasks.

Differently from most accelerators in literature, HWPEs do not rely on
an external DMA to feed them with input and to extract output, and they
are not (necessarily) tied to a single core. Rather, they operate
directly on the same memory that is shared by other elements in the PULP
system (e.g. the L1 TCDM in a PULP cluster, or the shared L2 in
PULPissimo). Their control is memory-mapped and accessed through a
peripheral bus or interconnect. HW-based execution on an HWPE can be
readily intermixed with software code, because all that needs to be
exchanged between the two is a set of pointers and, if necessary, a few
parameters.

.. figure:: img/hwpe.*
  :figwidth: 90%
  :width: 90%
  :align: center

  Template of a Hardware Processing Engine  (HWPE).

This document defines the interface protocols and modules that are used
to enable connecting HWPEs in a PULP system. Typically, such a module is
divided in a **streamer** interface towards the memory system, a
**control/peripheral** interface used for programming it, and an
**engine** containing the actual datapath of the accelerator.

***************************************************
HWPE Interface Modules: Data Movement \& Marshaling
***************************************************

Basic modules (HWPE-Stream)
===========================

Basic HWPE-Stream management modules are used to select multiple streams,
merge multiple streams into one, split a stream in multiple ones, synchronize
their handshakes and similar basic "morphing" functionality; or to delay
and enqueue streams.
Modules performing these functions can be found within the `rtl/basic` and
`rtl/fifo` subfolders of the `hwpe-stream` repository.

.. raw:: latex

    \clearpage

hwpe_stream_merge
-----------------

.. _hwpe_stream_merge:
.. svprettyplot:: ./ips/hwpe-stream/rtl/basic/hwpe_stream_merge.sv

.. raw:: latex

    \clearpage

hwpe_stream_split
-----------------

.. _hwpe_stream_split:
.. svprettyplot:: ./ips/hwpe-stream/rtl/basic/hwpe_stream_split.sv

.. raw:: latex

    \clearpage

hwpe_stream_fence
-----------------

.. _hwpe_stream_fence:
.. svprettyplot:: ./ips/hwpe-stream/rtl/basic/hwpe_stream_fence.sv

.. raw:: latex

    \clearpage

hwpe_stream_mux_static
----------------------

.. _hwpe_stream_mux_static:
.. svprettyplot:: ./ips/hwpe-stream/rtl/basic/hwpe_stream_mux_static.sv

.. raw:: latex

    \clearpage

hwpe_stream_demux_static
------------------------

.. _hwpe_stream_demux_static:
.. svprettyplot:: ./ips/hwpe-stream/rtl/basic/hwpe_stream_demux_static.sv

.. raw:: latex

    \clearpage

.. hwpe_stream_buffer
.. ------------------
..
.. .. _hwpe_stream_buffer:
.. .. svprettyplot:: ./ips/hwpe-stream/rtl/fifo/hwpe_stream_buffer.sv
..
.. .. raw:: latex
..
..     \clearpage

hwpe_stream_fifo
----------------

.. _hwpe_stream_fifo:
.. svprettyplot:: ./ips/hwpe-stream/rtl/fifo/hwpe_stream_fifo.sv

.. raw:: latex

    \clearpage

hwpe_stream_fifo_earlystall
---------------------------

.. _hwpe_stream_fifo_earlystall:
.. svprettyplot:: ./ips/hwpe-stream/rtl/fifo/hwpe_stream_fifo_earlystall.sv

.. raw:: latex

    \clearpage

hwpe_stream_fifo_ctrl
---------------------

.. _hwpe_stream_fifo_ctrl:
.. svprettyplot:: ./ips/hwpe-stream/rtl/fifo/hwpe_stream_fifo_ctrl.sv

.. raw:: latex

    \clearpage

HCI Core modules
================

hci_core_assign
---------------

.. _hci_core_assign:
.. svprettyplot:: ./ips/hci/rtl/core/hci_core_assign.sv

.. raw:: latex

    \clearpage

hci_core_fifo
-------------

.. _hci_core_fifo:
.. svprettyplot:: ./ips/hci/rtl/core/hci_core_fifo.sv

.. raw:: latex

    \clearpage

hci_core_mux_dynamic
--------------------

.. _hci_core_mux_dynamic:
.. svprettyplot:: ./ips/hci/rtl/core/hci_core_mux_dynamic.sv

.. raw:: latex

    \clearpage

hci_core_mux_ooo
----------------

.. _hci_core_mux_ooo:
.. svprettyplot:: ./ips/hci/rtl/core/hci_core_mux_ooo.sv

.. raw:: latex

    \clearpage

hci_core_mux_static
-------------------

.. _hci_core_mux_static:
.. svprettyplot:: ./ips/hci/rtl/core/hci_core_mux_static.sv

.. raw:: latex

    \clearpage

hci_core_r_id_filter
--------------------

.. _hci_core_r_id_filter:
.. svprettyplot:: ./ips/hci/rtl/core/hci_core_r_id_filter.sv

.. raw:: latex

    \clearpage

hci_core_r_valid_filter
-----------------------

.. _hci_core_r_valid_filter:
.. svprettyplot:: ./ips/hci/rtl/core/hci_core_r_valid_filter.sv

.. raw:: latex

    \clearpage

hci_core_split
--------------

.. _hci_core_split:
.. svprettyplot:: ./ips/hci/rtl/core/hci_core_split.sv

.. raw:: latex

    \clearpage

Basic modules (HWPE-Mem / HWPE-MemDecoupled - deprecated)
=========================================================

Basic HWPE-Mem management modules are used to delay/enqueue HWPE-MemDecoupled
interfaces, multiplex multiple HWPE-Mem, or reorder them before hooking the
accelerator to a Tightly-Coupled Data Memory (TCDM).
Modules performing these functions can be found within the `rtl/tcdm`
subfolder of the `hwpe-stream` repository.

.. raw:: latex

    \clearpage

hwpe_stream_tcdm_fifo_store
---------------------------

.. _hwpe_stream_tcdm_fifo_store:
.. svprettyplot:: ./ips/hwpe-stream/rtl/tcdm/hwpe_stream_tcdm_fifo_store.sv

.. raw:: latex

    \clearpage

hwpe_stream_tcdm_fifo_load
--------------------------

.. _hwpe_stream_tcdm_fifo_load:
.. svprettyplot:: ./ips/hwpe-stream/rtl/tcdm/hwpe_stream_tcdm_fifo_load.sv

.. raw:: latex

    \clearpage

hwpe_stream_tcdm_mux
--------------------

.. _hwpe_stream_tcdm_mux:
.. svprettyplot:: ./ips/hwpe-stream/rtl/tcdm/hwpe_stream_tcdm_mux.sv

.. raw:: latex

    \clearpage

hwpe_stream_tcdm_mux_static
---------------------------

.. _hwpe_stream_tcdm_mux_static:
.. svprettyplot:: ./ips/hwpe-stream/rtl/tcdm/hwpe_stream_tcdm_mux_static.sv

.. raw:: latex

    \clearpage

hwpe_stream_tcdm_reorder
------------------------

.. _hwpe_stream_tcdm_reorder:
.. svprettyplot:: ./ips/hwpe-stream/rtl/tcdm/hwpe_stream_tcdm_reorder.sv

.. raw:: latex

    \clearpage

.. hwpe_stream_tcdm_reorder_static
.. -------------------------------

.. .. _hwpe_stream_tcdm_reorder_static:
.. .. svprettyplot:: ./ips/hwpe-stream/rtl/tcdm/hwpe_stream_tcdm_reorder_static.sv

.. .. raw:: latex

..     \clearpage

HCI Streamer modules
====================

Streamer modules constitute the heart of the IPs use to interface HWPEs
with a PULP system. They include all the modules that are used to
generate HWPE-Streams from address patterns on the TCDM, including the
address generation itself, data realignment to enable access to data located
at non-byte-aligned addresses, strobe generation to selectively disable parts
of a stream, and the main streamer source and sink modules used to put
these functions together.
HCI Modules performing these functions can be found within the `rtl/core`
subfolder of the `hci` repository.

Two main streamer modules (**hci_core_source** and **hci_core_sink**)
are composite of several other IPs, including address generation and
strobe generation blocks included in this section, as well as of basic
HWPE-Stream management blocks.

hci_core_source
---------------

.. _hci_core_source:
.. svprettyplot:: ./ips/hci/rtl/core/hci_core_source.sv

.. raw:: latex

    \clearpage

hci_core_sink
-------------

.. _hci_core_sink:
.. svprettyplot:: ./ips/hci/rtl/core/hci_core_sink.sv

.. raw:: latex

    \clearpage

hwpe_stream_addressgen_v3
-------------------------

.. _hwpe_stream_addressgen_v3:
.. svprettyplot:: ./ips/hwpe-stream/rtl/streamer/hwpe_stream_addressgen_v3.sv

.. raw:: latex

    \clearpage

Plain HWPE-Mem Streamer modules (deprecated)
============================================

The "plain" HWPE-Mem Streamer modules, although still functional, have
generally been superseded by the HCI Streamer modules. We suggest using
those for new designs.

Streamer modules constitute the heart of the IPs use to interface HWPEs
with a PULP system. They include all the modules that are used to
generate HWPE-Streams from address patterns on the TCDM, including the
address generation itself, data realignment to enable access to data located
at non-byte-aligned addresses, strobe generation to selectively disable parts
of a stream, and the main streamer source and sink modules used to put
these functions together.
Modules performing these functions can be found within the `rtl/streamer`
subfolder of the `hwpe-stream` repository.

Two main streamer modules (**hwpe_stream_source** and **hwpe_stream_sink**)
are composite of several other IPs, including address generation and
strobe generation blocks included in this section, as well as of basic
HWPE-Stream management blocks.

.. raw:: latex

    \clearpage

hwpe_stream_source
------------------

.. _hwpe_stream_source:
.. svprettyplot:: ./ips/hwpe-stream/rtl/streamer/hwpe_stream_source.sv

.. raw:: latex

    \clearpage

hwpe_stream_sink
----------------

.. _hwpe_stream_sink:
.. svprettyplot:: ./ips/hwpe-stream/rtl/streamer/hwpe_stream_sink.sv

.. raw:: latex

    \clearpage

hwpe_stream_addressgen
----------------------

.. _hwpe_stream_addressgen:
.. svprettyplot:: ./ips/hwpe-stream/rtl/streamer/hwpe_stream_addressgen.sv

.. raw:: latex

    \clearpage

hwpe_stream_strbgen
-------------------

.. _hwpe_stream_strbgen:
.. svprettyplot:: ./ips/hwpe-stream/rtl/streamer/hwpe_stream_strbgen.sv

.. raw:: latex

    \clearpage

hwpe_stream_sink_realign
------------------------

.. _hwpe_stream_sink_realign:
.. svprettyplot:: ./ips/hwpe-stream/rtl/streamer/hwpe_stream_sink_realign.sv

.. raw:: latex

    \clearpage

hwpe_stream_source_realign
--------------------------

.. _hwpe_stream_source_realign:
.. svprettyplot:: ./ips/hwpe-stream/rtl/streamer/hwpe_stream_source_realign.sv

.. raw:: latex

    \clearpage

HCI Interconnect modules
========================

hci_router
----------

.. _hci_router:
.. svprettyplot:: ./ips/hci/rtl/interco/hci_router.sv

.. raw:: latex

    \clearpage

hci_arbiter
-----------

.. _hci_arbiter:
.. svprettyplot:: ./ips/hci/rtl/interco/hci_arbiter.sv

.. raw:: latex

    \clearpage

hci_interconnect
----------------

.. _hci_interconnect:
.. svprettyplot:: ./ips/hci/rtl/hci_interconnect.sv

.. raw:: latex

    \clearpage

Control interface modules (HWPE-Periph)
=======================================

The control interface of HWPEs exposes a HWPE-Periph interface that is used
to program a memory-mapped register file.
Several IPs can be used to compose the control interface, delivering a standard
accelerator control interface that is described below.
Modules performing these functions can be found within the `rtl/`
subfolder of the `hwpe-ctrl` repository.

.. Microcode processor
.. ~~~~~~~~~~~~~~~~~~~

.. The **hwpe_ctrl_ucode** module is a microcode processor that can be used
.. to execute the main computation block of an HWPE (implemented within the
.. “engine”) multiple times according to several rules, at the same time
.. adapting the value of several internal parameters. The microcode
.. processor can be used to execute a default number of 6 nested loops.

.. The microcode supports four R/W registers and twelve R/O registers (by
.. default); the microcode has two instructions: an **add** operation and a
.. **move** operation. The **add** operation performs RA := RA + RB; the
.. **move** operation performs RA := RB. R/O registers can only be used as
.. RB. The R/W registers can be used to generate offsets to program the
.. address generators, or for other purposes.

.. The microcode can be specified in a “high-level” fashion in terms of
.. YAML description, which can then be “compiled” by the *ucode_compile.py*
.. Python script, also within the *hwpe-ctrl* repository. The compiler
.. provides the two bit fields to be used to program the HWPE microcode
.. processor, typically this is either hardwired or passed through
.. job-independent registers.

.. Slave interface and register file
.. ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. The **hwpe_ctrl_slave** module implements the PERIPH slave interface.
.. The **hwpe_ctrl_regfile**, which is instantiated inside it, implements
.. the actual register file. The register file contains N_GENERIC_REGS
.. registers which are non-contexted, i.e. their value stays constant
.. between consecutive job offloads; and N_IO_REGS registers which are
.. contexted, i.e. which are used to implement a queue of jobs that can be
.. offloaded also when the HWPE is active. The slave module also generates
.. the events that are propagated in the PULP platform.

.. Sequential multiplier
.. ~~~~~~~~~~~~~~~~~~~~~

.. The **hwpe_ctrl_seq_mult** module is a utility module to implement a
.. sequential multiplier; it can be used to produce derivative parameters
.. e.g. for usage as read-only registers in the microcode processor. When
.. the *start* input is asserted, the multiplier will start compute the
.. product of the two inputs *a* and *b*. The sequential multiplier takes
.. *width(a)* cycles to compute the output and asserts a valid bit when the
.. product has been computed.
