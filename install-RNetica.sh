#!/bin/sh
set -ex
wget https://pluto.coe.fsu.edu/svn/common/RNetica/releases/RNetica_0.4-6.tgz
tar -xvf 'RNetica_0.4-6.tgz'
R CMD INSTALL RNetica --configure-args='--with-netica=/home/travis/build/egouldo/GrasslandAllocatr/src/Netica_API_504'