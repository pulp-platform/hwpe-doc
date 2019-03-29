
***************************************************
HWPE Interface Modules: Data Movement \& Marshaling
***************************************************

HWPE-Stream basic modules
=========================

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

Streamer modules
================

Streamer modules constitute the heart of the IPs use to interface HWPEs
with a PULP system. They include all the modules that are used to
generate HWPE-Streams from address patterns on the TCDM, including the
address generation itself, data realignment to enable access to data located
at non-byte-aligned addresses, strobe generation to selectively disable parts
of a stream, and the main streamer source and sink modules used to put
these functions together.
Modules performing these functions can be found within the `rtl/streamer`
subfolder of the `hwpe-stream` repository.

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

hwpe_stream_source
------------------

.. _hwpe_stream_source:
.. svprettyplot:: ./ips/hwpe-stream/rtl/streamer/hwpe_stream_source.sv

.. _hwpe_stream_source_archi:
.. figure:: img/hwpe_stream_source_archi.*
  :figwidth: 100%
  :width: 100%
  :align: center

  Architecture of the source streamer.

.. raw:: latex

    \clearpage

hwpe_stream_sink
----------------

.. _hwpe_stream_sink:
.. svprettyplot:: ./ips/hwpe-stream/rtl/streamer/hwpe_stream_sink.sv

.. raw:: latex

    \clearpage

.. Source realigner
.. ----------------

.. .. .. _hwpe_stream_source_realign:
.. .. .. svprettyplot:: ./ips/hwpe-stream/rtl/basic/hwpe_stream_source_realign.sv

.. ..   **hwpe_stream_source_realign** module.

.. The **hwpe_stream_source_realign** module is used to transform a strobed
.. (misaligned) stream of size DATA_WIDTH into a realigned stream of the
.. same size, taking as input a strobe generated from an address generator
.. (see below).

.. The module does not work for generic strobes, but rather it assumes that
.. strobes result in a *rotation*, which is what happens for streams
.. generated from a batch of misaligned transfers.

.. Sink realigner
.. ~~~~~~~~~~~~~~~

.. .. .. _hwpe_stream_sink_realign:
.. .. .. svprettyplot:: ./ips/hwpe-stream/rtl/basic/hwpe_stream_sink_realign.sv

.. ..   **hwpe_stream_sink_realign** module.

.. The **hwpe_stream_sink_realign** module is used to transform a stream of
.. size DATA_WIDTH into a realigned strobed stream of the same size, taking
.. as input a strobe generated from an address generator (see below).

.. The module does not work for generic strobes, but rather it assumes that
.. strobes result in a *rotation*, which is what happens for streams used
.. to generate from a batch of misaligned transfers.

.. TCDM / HWPE-Stream interface modules
.. ------------------------------------

.. At the interface between the TCDM and HWPE-Stream modules, the main
.. necessity is to generate an address for the streams. They also reside in
.. the *hwpe-stream* repository.

.. Address generator
.. ~~~~~~~~~~~~~~~~~

.. .. .. _hwpe_stream_source_realign:
.. .. .. svprettyplot:: ./ips/hwpe-stream/rtl/basic/hwpe_stream_source_realign.sv

.. ..   **hwpe_stream_source_realign** module.

.. The **hwpe_stream_addressgen** module is used to generate addresses to
.. load or store HWPE-Stream streams. The REALIGN_TYPE parameter is used to
.. generate appropriate strobes to realign the streams in the sink and
.. source cases.

.. The address generator can be used to generate address from a
.. three-dimensional space of “words”, “lines” and “features”. Lines and
.. features can be separated by a certain stride, and a roll parameter can
.. be used to reuse the same offsets multiple times.

.. While useful in accelerators (e.g. in the HWCE [1][2][5]) the multiple
.. loops are essentially supersed by the functionality provided by the
.. microcode processor that can be embedded in HWPEs. The usage of more
.. than a single loop is discouraged, i.e. the HWPE designer should
.. statically set line_stride=0, feat_length=1, feat_stride=0.

.. Source
.. ~~~~~~~

.. The **hwpe_stream_source** puts together an address generator, a stream
.. merger, and a source realigner to create an interface between
.. NB_TCDM_PORTS memory ports using the TCDM protocol (for loads alone) and
.. a stream of size DATA_WIDTH=NB_TCDM_PORTS*32.

.. Typically it is sufficient to instantiate directly this module instead
.. of the address generator, stream merger and source realigner alone.

.. Sink
.. ~~~~~

.. The **hwpe_stream_sink** puts together an address generator, a stream
.. splitter, and a sink realigner to create an interface between a stream
.. of size DATA_WIDTH=NB_TCDM_PORTS*32 and NB_TCDM_PORTS memory ports using
.. the TCDM protocol (for store alone).

.. Typically it is sufficient to instantiate directly this module instead
.. of the address generator, stream merger and sink realigner alone.

.. TCDM management modules
.. -----------------------

.. Modules to manage TCDM streams with address also reside within the
.. *hwpe-stream* repository.

.. TCDM FIFO (loads)
.. ~~~~~~~~~~~~~~~~~~

.. The **hwpe_stream_tcdm_fifo_load** module can be used to decouple loads
.. with two FIFOs (one for requests, one for responses). It is currently
.. not fully tested.

.. TCDM FIFO (stores)
.. ~~~~~~~~~~~~~~~~~~~

.. The **hwpe_stream_tcdm_fifo_store** module can be used to decouple
.. stores with a FIFO (for requests). It is currently not fully tested.

.. TCDM dynamic multiplexer
.. ~~~~~~~~~~~~~~~~~~~~~~~~

.. .. _hwpe_stream_tcdm_mux:
.. .. svprettyplot:: ./ips/hwpe-stream/rtl/tcdm/hwpe_stream_tcdm_mux.sv

..   **hwpe_stream_tcdm_mux** module.

.. The **hwpe_stream_tcdm_mux** module can be used to dynamically share
.. NB_IN_CHAN channels using the TCDM protocol into NB_OUT_CHAN channels,
.. with NB_OUT_CHAN < NB_IN_CHAN. The multiplexer is not “optimal” in the
.. sense that there is no reorder buffer, so transactions cannot be swapped
.. in-flight. In practice this limitation is compensated by the fact that
.. the cost of the reorder buffer is saved, and it works well in practice
.. in the Fulmine HWCE [1].

.. TCDM static multiplexer
.. ~~~~~~~~~~~~~~~~~~~~~~~

.. The **hwpe_stream_tcdm_mux_static** module is used to statically share
.. NB_CHAN ports using the TCDM protocol between two sets of NB_CHAN input
.. ports. It works similarly to the **hwpe_stream_mux_static** and
.. similarly requires a strictly static selector.

.. TCDM reorder block
.. ~~~~~~~~~~~~~~~~~~

.. The **hwpe_stream_tcdm_reorder** module is used to shuffle the order of
.. NB_CHAN channels using the TCDM protocol according to an external order,
.. that can be changed arbitrarily (e.g. with a counter). This is useful in
.. some cases (e.g. [1]) so that the probability of a transaction is
.. equalized between multiple ports.

.. PERIPH and controller modules
.. -----------------------------

.. The control interface of HWPEs exposes a PERIPH interface that is used
.. to program a memory-mapped register file. The *hwpe-ctrl* repository
.. contains several IPs that can be used to compose the control interface;
.. apart from the PERIPH interface, these modules are optional – and the
.. main control finite-state machines are accelerator-specific and have to
.. be designed from scratch in any case.

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
