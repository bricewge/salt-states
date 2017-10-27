include:
  - nfs.server

audiobook-feeds-user:
  group.present:
    - name: audiobook-feeds
    - gid: 516
  user.present:
    - name: audiobook-feeds
    - uid: 516
    - gid_from_name: True
    - home: /srv/audiobook-feeds
    - shell: /bin/false
    - empty_password: True
    - optional_groups:
      - nfs
    - require:
      - group: audiobook-feeds-user
      - group: nfs-group
