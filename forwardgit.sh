#!/bin/bash

# @dev Simply wraps git to rsync the current folder under ~/.forwardgit/ then
# @dev runs the git command in that folder.

# @dev set -x
FGITD=${HOME}/.forwardgit
DESTD=${FGITD}/$(basename "${PWD}")
[ -d "${DESTD}" ] || {
        mkdir -p "${DESTD}"
}

# @dev If there's no .gitignore, but there is a .forwardgit script with an ignore variable,
# @dev use the ignore value as the parameter to gitignore.io.

# shellcheck disable=SC2166
[ ! -f .gitignore -a -f .forwardgit ] && (
        # shellcheck disable=SC1091
        source .forwardgit
        [ "${ignore}" ] && {
                curl http://gitignore.io/api/"${ignore}" > .gitignore
        }
)

rsync -vazu --delete --exclude .git . "${DESTD}"/
cd "${DESTD}" || exit ${LINENO}

git "${@}"
exit ${?}

