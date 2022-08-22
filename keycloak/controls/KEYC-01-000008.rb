# -*- encoding : utf-8 -*-
control "KEYC-01-000008" do
  title "Keycloak must be configured to automatically audit account removal actions."
  desc  "When application accounts are removed, user accessibility is affected. Once an attacker establishes access to an application, the attacker often attempts to remove authorized accounts to disrupt services or prevent the implementation of countermeasures. Auditing account removal actions provides logging that can be used for forensic purposes."
  desc  "rationale", ""
  desc  "check", "
    If Keycloak relies on directory services for user account management, this is not applicable and the connected directory services must perform this function. 
    
    Verify Keycloak is configured to automatically audit account removal actions.
    
    If Keycloak is not configured to automatically audit account removal actions, this is a finding.
    
    To check if Keycloak is configured to audit account creation, you can run the following from a privileged account on the Keycloak admin CLI:
    
    kcadm.sh get events/config -r [your realm] | grep adminEvents
    
    If the results are not as follows, then it is a finding.
    
    \"adminEventsEnabled\" : true,
    \"adminEventsDetailsEnabled\" : true
  "
  desc  "fix", "
    Configure Keycloak to automatically audit account removal actions.
    
    To configure this setting using the Keycloak admin CLI, do the following from a privileged account:
    Update the configuration:
    
    kcadm.sh update events/config -r [your realm] -s adminEventsEnabled=true -s adminEventsDetailsEnabled=true
  "
  impact 0.5
  tag severity: "medium"
  tag gtitle: "SRG-APP-000029-AAA-000120"
  tag gid: nil
  tag rid: nil
  tag stig_id: "KEYC-01-000008"
  tag cci: ["CCI-001405"]
  tag nist: ["AC-2 (4)"]
end