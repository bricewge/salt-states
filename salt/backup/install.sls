borg-install:
  file.managed:
    - name: /usr/local/bin/borg
    - source: https://github.com/borgbackup/borg/releases/download/1.0.7/borg-linux64
    - source_hash: sha256=e1b5370bc55ce00eecbac459bc9751b540d48b7ba42168ad4e4505db175aa471
    - user: root
    - group: root
    - mode: 755
      
