Workstation VM
==============

How to use
----------

Copy `invocation.sh.example` to `invocation.sh` and edit it to use your public
and private keys, and edit it to whitelist the IP addresses of the systems you
would be testing from.  Also put your name in as the prefix, and add your email
address.

This is how it looks for me:

```
#!/bin/bash -x
time terraform "$@" -var email=med.mahmoud@dominodatalab.com -var prefix=med -var public_key_path=~/.ssh/foo.pub -var private_key_path=~/.ssh/foo -var 'cidrs=["34.0.111.222/32"]'
```

Then `invocation.sh plan` and `invocation.sh apply` to spin up the system.

