Protocol (wire format):
========

written in BASE Pmodp protocol
it provides a framing/handshaking for:
- definition of the IDL Adapter to use
- sending of the Pmodp messaging
- Command list of the Pmodp protocol. Categorization and definition of the way the header should be ordered (this has to be related for the later mapping of the Adapters to this requirements). For example: in order for ZMQ socket subscriptions to work, the initial chars of the string must represent a unique destination.

Something like: [<category_code>, <msg_type>]

IDL - Schema
============

the syntax and metadata information for the IDL used between modules.
- it provides validation mechanisms, both at integrity level (checksum) and syntax level.
- definition of the BASE IDL format.
- it provides the parsing/generation of this IDL, by interfacing with some of the integrated adapters.

IDL - Adapters
==============
- it provides an adapter to serialize/deserialize the BASE IDL format.
- it provides an adapter to serialize/deserialize the MsgPack format.
- it provides an adapter to serialize/deserialize the JSON format.
- it provides an adapter to serialize/deserialize the BERT format.
- it provides an adapter to serialize/deserialize the Avro format.

IDL - Components
================
- Context
- DataObject
- Roles
- Algorithm
