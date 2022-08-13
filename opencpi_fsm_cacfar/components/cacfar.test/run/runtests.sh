#!/bin/bash --noprofile
source $OCPI_CDK_DIR/scripts/util.sh
failed=0
if onlyExclude xsim "$OnlyPlatforms" "$ExcludePlatforms"; then
  (cd ./run/xsim && ./run.sh $*)
  r=$?
          [ $r = 130 -o \( $r != 0 -a "" != 1 \) ] && exit $r
          [ $r != 0 ] && failed=1
fi
exit $failed
