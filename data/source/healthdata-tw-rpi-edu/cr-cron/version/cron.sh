#!/bin/bash
#
#3> <> rdfs:seeAlso <https://github.com/jimmccusker/twc-healthdata/wiki/Automation>;
#3>    prov:specializationOf <https://raw.github.com/jimmccusker/twc-healthdata/master/data/source/healthdata-tw-rpi-edu/cr-cron/version/cron.sh> .
#
#3> <https://raw.github.com/jimmccusker/twc-healthdata/master/data/source/healthdata-tw-rpi-edu/cr-cron/version/cron.sh>
#3>    foaf:homepage <https://github.com/jimmccusker/twc-healthdata/blob/master/data/source/healthdata-tw-rpi-edu/cr-cron/version/cron.sh> .

pushd `dirname $0` &> /dev/null

   source ../../../csv2rdf4lod-source-me-as-`whoami`.sh
   source ../../../csv2rdf4lod-source-me-when-ckaning.sh

   versionID=`md5.sh $0` # - - - needs - /\
   mkdir -p $versionID/doc/logs
   logID=`date +%Y-%b-%d_%H_%M`
   log=$versionID/doc/logs/cron-$logID.log # - - - - - - - - - log - - - - - - - - - - - - - - -

   echo "BEGIN cron git pull `date`"    >> $log
   if [ `which git` ]; then
      git pull 2>&1                     >> $log
   else
      echo "ERROR: git is not on PATH"  >> $log
   fi
   echo "END cron git pull `date`"      >> $log
  
 
   echo "BEGIN cron cr-vars.sh `date`"      >> $log
   echo "user name: $SUDO_USER as `whoami`" >> $log
   cr-vars.sh                               >> $log
   echo "END cron cr-vars.sh `date`"        >> $log


   echo "BEGIN cron cr-mirror-ckan.py"                                                   >> $log
   if [[  "$CSV2RDF4LOD_CKAN" == "true"      && \
         ${#CSV2RDF4LOD_CKAN_SOURCE}   -gt 0 && \
         ${#CSV2RDF4LOD_CKAN_WRITABLE} -gt 0 && \
         ${#X_CKAN_API_Key}            -gt 0 && \
         `which cr-mirror-ckan.py` ]]; then
      echo cr-mirror-ckan.py $CSV2RDF4LOD_CKAN_SOURCE/api $CSV2RDF4LOD_CKAN_WRITABLE/api >> $log
      cr-mirror-ckan.py $CSV2RDF4LOD_CKAN_SOURCE/api $CSV2RDF4LOD_CKAN_WRITABLE/api 2>&1 >> $log
   else
      echo "   ERROR: Failed to invoke cr-mirror-ckan.py:"               >> $log
      echo "      CSV2RDF4LOD_CKAN:          $CSV2RDF4LOD_CKAN"          >> $log
      echo "      CSV2RDF4LOD_CKAN_SOURCE:   $CSV2RDF4LOD_CKAN_SOURCE"   >> $log
      echo "      CSV2RDF4LOD_CKAN_WRITABLE: $CSV2RDF4LOD_CKAN_WRITABLE" >> $log
      echo "      cr-mirror-ckan.py path:    `which cr-mirror-ckan.py`"  >> $log
      echo "      X_CKAN_API_Key:            $X_CKAN_API_Key"            >> $log
   fi
   echo "BEGIN cron cr-mirror-ckan.py"                                                   >> $log


   echo "END cron" >> $log
popd &> /dev/null
