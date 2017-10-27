base:
  '*':
    - snoopy-install

  'host:snoopy-server':
    - match: grain
    - snoopy-server