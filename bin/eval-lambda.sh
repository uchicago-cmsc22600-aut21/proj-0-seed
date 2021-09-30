#!/bin/sh
#
# Shell wrapper for Lambda-calculus evaluator
#
# CMSC 22600 --- Compilers for Computer Languages
# Autumn 2021
# University of Chicago
#

LAMBDA_EVAL=$0
BINDIR=${LAMBDA_EVAL%eval-lambda.sh}

HEAP_SUFFIX=$(sml @SMLsuffix)

HEAP=$BINDIR/eval-lambda.$HEAP_SUFFIX

if test ! -r $HEAP ; then
  echo "Heap image $HEAP not found; run make to build"
  exit 1
fi

exec sml @SMLcmdname=eval-lambda @SMLload=$HEAP $@
