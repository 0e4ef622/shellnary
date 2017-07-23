shellnary
=========

A set of functions written in _pure bash_ for reading binary data.

## Functions

* `read_{l,b}e{u,i}{8,16,32} <fd>` where `le`/`be` stands for
little endian/big endian and `u`/`i` stands for unsigned/signed
respectively. Does exactly what you think it would do.
* `read_{l,b}ei64 <fd>` There's no unsigned 64 bit :(
* `forward_seek <bytes> <fd>` Read `<bytes>` bytes and throw them away,
effectively seeking forward (there is no backward seek unfortunately).

## TODO

* Add functions for writing
* Add a function for seeking forward
* Support LEB128 and VLQ
