#!/bin/bash
V_VERSION="0.9.9"
# download and unzip validator
mkdir -p build/validation
cd build/validation
rm -r *
wget http://central.maven.org/maven2/de/isas/mztab/jmztabm-cli/$V_VERSION/jmztabm-cli-$V_VERSION-bin.zip
unzip jmztabm-cli-$V_VERSION-bin.zip
cd jmztabm-cli

# alternatives: Warn or Error
V_LEVEL="Info"
V_FAILED=()
# run validation for all example files
for i in $(find ../../../examples/2_0-Metabolomics_Draft/ -maxdepth 1 -iname '*.mztab'); do
  echo -e "################################################################################"
  echo -e "# Starting validation of $i on level "
# semantic validation may take quite some time for larger files  
#  java -jar jmztabm-cli-$V_VERSION.jar -check inFile=$i -checkSemantic mappingFile=cv-mapping/mzTab-M-mapping.xml -level $V_LEVEL
  java -jar jmztabm-cli-$V_VERSION.jar -check inFile=$i -level $V_LEVEL
  if [ $? -ne 0 ];
  then
    echo -e "# Validation of file $i failed! Please check console output for errors!"
    V_FAILED+=($i)
  else
    echo -e "# Validation of file $i was successful. Please check console output for hints for improvment!"
  fi
  echo -e "################################################################################"
done

if [ ${#V_FAILED[@]} -ne 0 ]; then
  echo -e "################################################################################"
  echo -e "# Validation failed for ${#V_FAILED[@]} files! Please check the following files:"
  for i in "${V_FAILED[@]}"
  do
   echo "# $i"
  done
  echo -e "################################################################################"
else
  echo -e "################################################################################"
  echo -e "# Validation of all files successful!"
  echo -e "################################################################################"
  exit 0
fi
