#!/bin/sh
set -ex
wget https://pluto.coe.fsu.edu/svn/common/RNetica/releases/RNetica_0.4-6.tar.gz
tar -xvf 'RNetica_0.4-6.tar.gz'
R CMD INSTALL RNetica --configure-args='--with-netica=/home/travis/build/egouldo/GrasslandAllocatr/Netica_API_504/'
rm -r ./RNetica/
