# -*- encoding : utf-8 -*-
control "KEYC-01-000018" do
  title "Keycloak must be configured to generate audit records overwriting the oldest audit records in a first-in-first-out manner."
  desc  "
    It is critical that when Keycloak are at risk of failing to process audit logs as required, they take action to mitigate the failure. Audit processing failures include software/hardware errors, failures in the audit capturing mechanisms, and audit storage capacity being reached or exceeded. Responses to audit failure depend upon the nature of the failure mode. 
    
    For Keycloak, availability is an overriding concern, and so both of the following approved actions in response to an audit failure must be met:
    
    (i) If the failure was caused by the lack of audit record storage capacity, Keycloak must continue generating audit records if possible (automatically restarting the audit service if necessary), overwriting the oldest audit records in a first-in-first-out manner.
    (ii) If audit records are sent to a centralized collection server and communication with this server is lost or the server fails, Keycloak must queue audit records locally until communication is restored or until the audit records are retrieved manually. Upon restoration of the connection to the centralized collection server, action should be taken to synchronize the local audit data with the collection server.
  "
  desc  "rationale", ""
  desc  "check", "
    Verify Keycloak are configured to generate audit records overwriting the oldest audit records in a first-in-first-out manner. When failures are caused by the lack of audit record storage capacity, Keycloak must continue generating audit records. 
    
    If Keycloak are not configured to generate audit records overwriting the oldest audit records in a first-in-first-out manner, this is a finding.
    
    Check keycloak configuration file, keycloak.conf. If the file does not contain the following key-value pairs, it is a finding. 
    
    log=file,[OTHER LOGGING HANDLERS]
    
    Locate file quarkus.properties. If such a file is not found, this is a finding. 
    
    Inspect file quarkus.properties. If the content does not contain the following, this is a finding. 
    
    quarkus.log.file.rotation.max-file-size=[APPROPRIATE FILE SIZE]
    quarkus.log.file.rotation.max-backup-index=[APPROPRIATE NUMBER OF BACKUPS]
    quarkus.log.file.rotation.file-suffix=[APPROPRIATE SUFFIX]
  "
  desc  "fix", "
    Configure Keycloak to generate audit records overwriting the oldest audit records in a first-in-first-out manner. Some specific implementations may further require automatically restarting the audit service to synchronize the local audit data with the collection server. The configuration must continue generating audit records, even when failures are caused by the lack of audit record storage capacity.
    
    Create or update Keycloak logging handlers with the following lines in your Keycloak configuration file, keycloak.conf:
    
    log=file,[OTHER LOGGING HANDLERS]
    
    Creat or modify file quarkus.properties with addtion of following lines: 
    
    quarkus.log.file.rotation.max-file-size=[APPROPRIATE FILE SIZE]
    quarkus.log.file.rotation.max-backup-index=[APPROPRIATE NUMBER OF BACKUPS]
    quarkus.log.file.rotation.file-suffix=[APPROPRIATE SUFFIX]
  "
  impact 0.5
  tag severity: "medium"
  tag gtitle: "SRG-APP-000109-AAA-000300"
  tag gid: nil
  tag rid: nil
  tag stig_id: "KEYC-01-000018"
  tag cci: ["CCI-000140"]
  tag nist: ["AU-5 b"]
end