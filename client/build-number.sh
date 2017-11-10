#!/bin/bash

number=`cat number.txt`
number=$((number+1))
echo $number > number.txt
echo "module Build exposing (number)" > gen/Build.elm
echo "number=$number" >> gen/Build.elm
