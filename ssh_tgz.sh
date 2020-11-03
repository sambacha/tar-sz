#!/bin/bash

( ${#} >= 3; ) || { echo "usage: $(basename "${0}") github-username archive-file [files | directories]"; exit 1; }

exec >"${2}"

zero="${0}"
cat <<SCRIPT
#!/usr/bin/env bash
usage() {
	echo "usage: bash ${zero} identity-file"
	echo "encrypted using: github.com/${1}.keys"
	echo "               : $(curl -s -L https://github.com/"${1}".keys | head -1)"
	[[ -f ~/.ssh/id_rsa-${1} ]] && bash \${0} ~/.ssh/id_rsa-${1}
	exit
}
SCRIPT

cat <<'SCRIPT'
(( ${#} >= 1 )) || usage "${@}"
trap "rm -f /tmp/pass.${$} 2>/dev/null" 0
openssl rsautl -decrypt -inkey ${1} -out /tmp/pass.${$} -in <(head -14 ${0} | tail -1 | perl -p -e 's/\\n/\n/g' | openssl base64 -d)
tail -n+15 ${0} | openssl enc -aes-256-cbc -d -a -pass file:/tmp/pass.${$} | tar ${2:-xv}z
exit
SCRIPT

# SC2155: Declare and assign separately to avoid masking return values.
pass=$(openssl rand -hex 64)
export pass

openssl rsautl -encrypt -pubin \
	-in <(echo -n "${pass}") \
	-inkey <(ssh-keygen -e -f <(curl -s -L https://github.com/"${1}".keys | head -1) -m PKCS8) \
| openssl base64 \
| perl -p -e 's/\n/\\n/g'
echo
tar zc "${@:3}" | openssl enc -aes-256-cbc -a -salt -pass env:pass
chmod +x "${2}"
