#!/bin/bash
#
#3> <> rdfs:seeAlso <https://github.com/jimmccusker/twc-healthdata/wiki/Automation>;
#3>    prov:specializationOf <https://raw.github.com/jimmccusker/twc-healthdata/master/data/source/healthdata-tw-rpi-edu/cr-cron/version/cron.sh> .
#
#3> <https://raw.github.com/jimmccusker/twc-healthdata/master/data/source/healthdata-tw-rpi-edu/cr-cron/version/cron.sh>
#3>    foaf:homepage <https://github.com/jimmccusker/twc-healthdata/blob/master/data/source/healthdata-tw-rpi-edu/cr-cron/version/cron.sh> .

pushd `dirname $0` &> /dev/null
   source ../../../csv2rdf4lod-source-me-as-root.sh
   source ../../../csv2rdf4lod-source-me-when-ckaning.sh

   versionID=`md5.sh $0`
   logID=`date +%Y-%b-%d_%H_%M`
   mkdir -p $versionID/doc/logs
   log=$versionID/doc/logs/cron-$logID.log

   cr-vars.sh >> $log

   if [[ "$CSV2RDF4LOD_CKAN" == "true" && \
         ${#CSV2RDF4LOD_CKAN_SOURCE} -gt 0 && ${#CSV2RDF4LOD_CKAN_WRITABLE} -gt 0 && \
         `which cr-mirror-ckan.py` && ${#X_CKAN_API_Key} -gt 0 ]]; then
      echo cr-mirror-ckan.py $CSV2RDF4LOD_CKAN_SOURCE $CSV2RDF4LOD_CKAN_WRITABLE
   else
      echo "ERROR: Failed to invoke cr-mirror-ckan.py:"
      echo "   CSV2RDF4LOD_CKAN:               $CSV2RDF4LOD_CKAN"
      echo "   CSV2RDF4LOD_CKAN_SOURCE:        $CSV2RDF4LOD_CKAN_SOURCE"
      echo "   CSV2RDF4LOD_CKAN_CKAN_WRITABLE: $CSV2RDF4LOD_CKAN_CKAN_WRITABLE"
      echo "   `which cr-mirror-ckan.py`"
      echo "   X_CKAN_API_Key:                 $X_CKAN_API_Key" 
   fi
popd &> /dev/null
