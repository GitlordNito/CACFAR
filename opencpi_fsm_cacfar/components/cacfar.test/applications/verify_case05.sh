#!/bin/bash --noprofile
# Verification and/or viewing script for case: case05
# Args are: <worker> <subcase> <verify> <view>
# Act like a normal process if get this signal
trap 'exit 130' SIGINT
function isPresent {
  local key=$1
  shift
  local vals=($*)
  for i in $*; do if [ "$key" = "$i" ]; then return 0; fi; done
  return 1
}
worker=$1; shift
subcase=$1; shift
! isPresent run $* || run=run
! isPresent view $* || view=view
! isPresent verify $* || verify=verify
if [ -n "$verify" ]; then
  if [ -n "$view" ]; then
    msg="Viewing and verifying"
  else
    msg=Verifying
  fi
elif [ -n "$view" ]; then
  msg=Viewing
else
  exit 1
fi
eval export OCPI_TESTCASE=case05
eval export OCPI_TESTSUBCASE=$subcase
exitval=0
echo '  '$msg case case05.$subcase for worker "$worker" using script on output file:  case05.$subcase.$worker.output.out
while read comp name value; do
  [ $comp = "cacfar" ] && eval export OCPI_TEST_$name=\"$value\"
done < case05.$subcase.$worker.props
case $subcase in
  (00) export OCPI_TEST_test_case='case05';;
esac
[ -z "$verify" ] || {
  PATH=../..:../../$OCPI_TOOL_DIR:$OCPI_PROJECT_DIR/scripts:$PATH PYTHONPATH=$OCPI_PROJECT_DIR/scripts:$PYTHONPATH  verify.py case05.$subcase.$worker.output.out  ../../gen/inputs/case05.$subcase.input
  r=$?
  tput bold 2>/dev/null
  if [ $r = 0 ] ; then 
    tput setaf 2 2>/dev/null
    echo '    Verification for port output: PASSED'
  else
    tput setaf 1 2>/dev/null
    echo '    Verification for port output: FAILED'
    failed=1
  fi
  tput sgr0 2>/dev/null
  [ $r = 0 ] || exitval=1
}
exit $exitval
