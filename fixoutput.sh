#!/bin/sh

BDIR="$(pwd)/output"

cd ${BDIR}/feed;
ln -f -s all.rss.xml index.html;
mkdir -p ${BDIR}/feed/atom;
cd ${BDIR}/feed/atom;
ln -f -s ../all.atom.xml index.html;

cd ${BDIR}/category;
for CAT in * ; do
  cd ${BDIR}/category;
  test -d ${CAT} || continue;
  cd ${CAT}/feed;
  ln -f -s rss.xml index.html;
  mkdir -p atom;
  cd atom;
  ln -f -s ../atom.xml index.html;
done
