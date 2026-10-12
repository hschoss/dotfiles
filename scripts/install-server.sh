#!/usr/bin/env sh
# install-server.sh — Server profile.
#
# Currently installs the same packages as the common profile. Kept as a
# separate entry point so server-only packages (and the exclusion of
# dev-only ones) can be added later without changing the common install
# flow.

set -eu
exec "$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)/install-common.sh" "$@"
