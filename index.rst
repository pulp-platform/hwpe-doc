.. Hardware Processing Engines - Interface Specifications documentation master file, created by
   sphinx-quickstart on Sun Mar  3 23:38:08 2019.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

===========================
Hardware Processing Engines
===========================

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

For more information on HWPEs and their properties, see references
[1]-[5].

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

.. toctree::
  :maxdepth: 3
  :caption: Contents:

  revisions
  protocols
  modules

.. raw:: latex

  \listoffigures
  \listoftables
