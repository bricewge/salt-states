#  GitLab Runner (for CI)
# * Install
# GitLab repository
gitlab-runner-repo:
  pkgrepo.managed:
    - humanname: GitLab Runner repo
    - name: deb https://packages.gitlab.com/runner/gitlab-ci-multi-runner/debian/ jessie main
    - file: /etc/apt/sources.list.d/gitlab-runner.list
    - key_url: https://packages.gitlab.com/gpg.key
    - require_in: gitlab-install
    - require:
      - pkg: apt-transport-https
  pkg.installed:
    - name: apt-transport-https

# Install Gitlab runner
gitlab-runner-install:
  pkg.installed:
    - name: gitlab-ci-multi-runner
    - require:
      - pkgrepo: gitlab-runner-repo

# # * User
# gitlab-runner-user:
#   group.present:
#     - name: gitlab-runner
#     - gid: 504
#   user.present:
#     - name: gitlab-runner
#     - uid: 504
#     - gid_from_name: True
#     - system: True
#     - home: /home/gitlab-runner
#     - shell: /bin/false
#     - require:
#       - group: gitlab-runner

# * Service
gitlab-runner-service:
  service.running:
    - name: gitlab-runner
    - enable: True
    - require:
      - pkg: gitlab-runner-install
      # - user: gitlab-runner-user

# * Register

# TODO register, dones't work for the moment 2016-05-10
# sudo gitlab-runner register --url https://git.bricewge.fr/ci -r oJGVu6CCuJJ_JzgAp9H7 \
# --executor docker --docker-image debian:latest -n
