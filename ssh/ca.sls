ssh-ca-key:
  cmd.run:
    - name: ssh-keygen -P "" -f test-backup
    - user: root
    - cwd: /etc/pki/test-backup
    - creates:
      - /etc/pki/test-backup
      - /etc/pki/test-backup.pub

ssh-ca-certificate:
  module.run:
    - name: mine.send
    - func: file.grep
    - kwargs:
        path: /etc/pki/test-backup.pub
    - onchanges:
      -cmd: ssh-ca-key

    
