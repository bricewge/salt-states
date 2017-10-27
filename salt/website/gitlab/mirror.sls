# Gitalb repostories that need to be sync elsewhere
include:
  - .gitlab

gitlab.mirror.github:
  file.directory:
    - name: /var/opt/gitlab/.ssh/github
    - user: git
    - group: git
    - mode: 700
    - require:
      - cmd: gitlab-config

# * bricewge/dotfiles
gitlab.bricewge.dotfiles.ssh:
  cmd.run:
    - name: ssh-keygen -q -N '' -f /var/opt/gitlab/.ssh/github/bricewge-dotfiles.key
    - user: git
    - creates: /var/opt/gitlab/.ssh/github/bricewge-dotfiles.key
    - require:
      - file: gitlab.mirror.github
  file.append:
    - name: /var/opt/gitlab/.ssh/config
    - text: |
        Host github-bricewge-dotfiles  
             IdentityFile /var/opt/gitlab/.ssh/github/bricewge-dotfiles.key
             HostName github.com  
             User git
             StrictHostKeyChecking no
    - require:
      - cmd: gitlab.bricewge.dotfiles.ssh

gitlab.bricewge.dotfiles.git.remote:
  file.blockreplace:
    - name: /var/opt/gitlab/git-data/repositories/bricewge/dotfiles.git/config
    - content: |
        [remote "github"]
        	url = github-bricewge-dotfiles:bricewge/dotfiles.git
        	fetch = +refs/*:refs/*
        	mirror = true
    - marker_start: "#-- start salt managed zone: gitlab.bricewge.dotfiles.git.remote --"
    - marker_end: "#-- end salt managed zone --"
    - append_if_not_found: True
    - context:
      - user: git
      - group: git
    - require:
      - file: gitlab.bricewge.dotfiles.ssh

gitlab.bricewge.dotfiles.git.hook:
  file.managed:
    - name: /var/opt/gitlab/git-data/repositories/bricewge/dotfiles.git/custom_hooks/post-receive
    - contents: |
        #!/bin/sh
        git push --quiet github
    - user: git
    - group: git
    - makedirs: True
    - mode: 755
    - require:
      - file: gitlab.bricewge.dotfiles.git.remote
