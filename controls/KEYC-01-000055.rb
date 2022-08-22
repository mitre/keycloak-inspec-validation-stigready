# -*- encoding : utf-8 -*-
control "KEYC-01-000055" do
  title "Keycloak must be configured to send audit records to a centralized audit server."
  desc  "
    Information stored in one location is vulnerable to accidental or incidental deletion or alteration.
    
    Off-loading is a common process in information systems with limited audit storage capacity.
  "
  desc  "rationale", ""
  desc  "check", "
    Verify Keycloak are configured to send audit records to a centralized audit server.
    
    If Keycloak are not configured to send audit records to a centralized audit server, this is a finding.
    
    Check keycloak configuration file, keycloak.conf. If the file does not contain the following key-value pairs, it is a finding. 
    
    log=gelf,[OTHER LOGGING HANDLERS]
  "
  desc  "fix", "
    Configure Keycloak to send audit records to a centralized audit server.
    
    Create or update Keycloak logging handlers with the following lines in your keycloak configuration file, keycloak.conf:
    
    log=console,gelf 
    log-gelf-host=[APPROPRIATE HOST]
    log-gelf-port=[APPROPRIATE PORT]
  "
  impact 0.5
  tag severity: "medium"
  tag gtitle: "SRG-APP-000358-AAA-000280"
  tag gid: nil
  tag rid: nil
  tag stig_id: "KEYC-01-000055"
  tag cci: ["CCI-001851"]
  tag nist: ["AU-4 (1)"]
end