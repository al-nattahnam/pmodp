Protocol (wire format):
========

written in BASE Pmodp protocol
it provides a framing/handshaking for:
- definition of the IDL Adapter to use
- sending of the Pmodp messaging
- Command list of the Pmodp protocol. Categorization and definition of the way the header should be ordered (this has to be related for the later mapping of the Adapters to this requirements). For example: in order for ZMQ socket subscriptions to work, the initial chars of the string must represent a unique destination.

Something like: [<checksum>, <category_code>, <msg_type>]
