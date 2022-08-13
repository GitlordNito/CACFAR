#!/bin/bash --noprofile
# Note that this file runs on remote/embedded systems and thus
# may not have access to the full development host environment
failed=0
. $OCPI_CDK_DIR/scripts/testrun.sh local.cacfar.cacfar xsim "" $* - output
docase hdl cacfar case00 00 3600 0 output
docase hdl cacfar case01 00 3600 0 output
docase hdl cacfar case02 00 3600 0 output
docase hdl cacfar case03 00 3600 0 output
docase hdl cacfar case04 00 3600 0 output
docase hdl cacfar case05 00 3600 0 output
docase hdl cacfar case06 00 3600 0 output
exit $failed
