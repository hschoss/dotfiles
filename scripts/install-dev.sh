#!/usr/bin/env sh
# install-dev.sh — Developer-machine profile.
#
# Currently installs the same packages as the common profile. Kept as a
# separate entry point so dev-only packages can be added later without
# changing the common install flow.

set -eu
exec "$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)/install-common.sh" "$@"
