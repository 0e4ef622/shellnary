shellnary
=========

A set of functions written in _pure bash_ for reading binary data.

## Functions

* `read_{l,b}e{u,i}{16,32} <fd>` where `le`/`be` stands for
little endian/big endian, `u`/`i` stands for unsigned/signed,
and `fd` stands for file descriptor. Does exactly what you think
it would do.
* `read_{u,i}8 <fd>` Endianness doesn't really make sense for 1 byte
numbers
* `read_{l,b}ei64 <fd>` There's no unsigned 64 bit :(
* `forward_seek <bytes> <fd>` Read `<bytes>` bytes and throw them away,
effectively seeking forward (there is no backward seek unfortunately).

Simple example:

```bash
$ file image.png
image.png: PNG image data, 313 x 102, 8-bit/color RGB, non-interlaced
$ . shellnary.sh
$ exec 3<>image.png
$ forward_seek 16 3
$ width=$(read_beu32 3)
$ height=$(read_beu32 3)
$ echo $width x $height
313 x 102
```

## TODO

* Add functions for writing
* Add a function for seeking forward
* Support LEB128 and VLQ
