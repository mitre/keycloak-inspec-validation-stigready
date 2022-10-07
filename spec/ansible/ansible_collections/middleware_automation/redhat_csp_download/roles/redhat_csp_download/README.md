redhat-csp-download
=========

Downloads resources from the Red Hat Customer Portal.

Requirements
------------
The lxml and requests packages are required. A full list of requirements is found in the metadata file

Examples
-------------

    - name: Download JBoss EAP Zip
      redhat_csp_download: 
        username=foo@example.com
        password=bar 
        url=https://access.redhat.com/jbossnetwork/restricted/softwareDownload.html?softwareId=37193
        dest=/tmp/eap-connectors.zip

Authors Information
------------------

* [Andrew Block](https://github.com/sabre1041)

