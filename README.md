# cherrybomb

Tiny secure deletion script running on bash & dd. Recursively writes random data to files then deletes them and the directory.

# Usage

```bash
 $ ./cherrybomb.sh -t eve
  Using block size of 512B
  Wiping file contents...
    eve/2
    eve/1
    eve/3/5/6
    eve/3/4
  Removing files...
  Removing directory...
 $ ./cherrybomb.sh -t eve -b 1M
  Using block size of 1MB
   [...]
 $ ./cherrybomb.sh -t eve -n
  Dry run - Printing commands but not executing them
  [...]
```

