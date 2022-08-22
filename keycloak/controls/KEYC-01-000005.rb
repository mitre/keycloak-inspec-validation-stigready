# -*- encoding : utf-8 -*-
control "KEYC-01-000005" do
  title "Keycloak must be configured to automatically audit account creation."
  desc  "Once an attacker establishes access to a system, the attacker often attempts to create a persistent method of reestablishing access. One way to accomplish this is for the attacker to simply create a new account. Auditing of account creation is one method for mitigating this risk. A comprehensive account management process will ensure an audit trail documents the creation of user accounts and, as required, notifies administrators and/or managers. Such a process greatly reduces the risk that accounts will be surreptitiously created and provides logging that can be used for forensic purposes."
  desc  "rationale", ""
  desc  "check", "
    If Keycloak relies on directory services for user account management, this is not applicable and the connected directory services must perform this function. 
    
    Verify Keycloak is configured to automatically audit account creation.
    
    If Keycloak is not configured to automatically audit account creation, this is a finding.
    
    To check if Keycloak is configured to audit account creation, you can run the following commands from a privileged account on the Keycloak admin CLI:
    
    kcadm.sh get events/config -r [your realm] | grep adminEvents
    
    If the results are not as follows, then it is a finding.
    
    \"adminEventsEnabled\" : true,
    \"adminEventsDetailsEnabled\" : true
  "
  desc  "fix", "
    Configure Keycloak to automatically audit account creation.
    
    To configure this setting using the Keycloak admin CLI, do the following from a privileged account:
    Update the configuration:
    
    kcadm.sh update events/config -r [your realm] -s adminEventsEnabled=true -s adminEventsDetailsEnabled=true
  "
  impact 0.5
  tag severity: "medium"
  tag gtitle: "SRG-APP-000026-AAA-000090"
  tag gid: nil
  tag rid: nil
  tag stig_id: "KEYC-01-000005"
  tag cci: ["CCI-000018"]
  tag nist: ["AC-2 (4)"]
end