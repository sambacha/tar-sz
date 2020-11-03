#!/usr/bin/env bash
# Useful for, for example, versioning docker images built from subdirectories in a mono-repo.
cd ${1:-.} || exit
git ls-tree -r --name-only $(git rev-parse --symbolic-full-name --abbrev-ref HEAD) \
| while read f; do [[ -d "${f}" ]] || [[ -f "${f}" ]] && echo ${f}; done \
| sort -fd \
| tr '\n' '\0' \
| xargs -0 openssl sha1 \
| openssl sha1
