# -*- encoding : utf-8 -*-
control "KEYC-01-000013" do
  title "Keycloak configuration audit records must identify where the events occurred."
  desc  "
    Without establishing where events occurred, it is impossible to establish, correlate, and investigate the events relating to an incident.
    
    In order to compile an accurate risk assessment, and provide forensic analysis, it is essential for security personnel to know where events occurred, such as application components, modules, session identifiers, filenames, host names, and functionality. 
    
    Associating information about where the event occurred within the application provides a means of investigating an attack; recognizing resource utilization or capacity thresholds; or identifying an improperly configured application.
  "
  desc  "rationale", ""
  desc  "check", "
    Verify Keycloak configuration audit records identify where the events occurred.
    
    If Keycloak configuration audit records do not identify where the events occurred, this is a finding.
    
    To confirm this setting is configured using the Keycloak admin CLI, after logging in with a privileged account, which can be done by running:
    
    kcadm.sh config credentials --server [server location] --realm master --user [username] --password [password]
    
    then run the following command:
    
    kcadm.sh get events/config -r [YOUR REALM] 
    
    If the results are not as follows, then it is a finding.
    
    \"eventsEnabled\" : true, 
    \"eventsListeners\" : [ \"jboss-logging\" ],
    \"enabledEventTypes\" : [ APPROPRIATE EVENT TYPES ]
    \"adminEventsEnabled\" : true,
    \"adminEventsDetailsEnabled\" : true
    
    Then run the command: 
    
    kcadm.sh get events 
    
    If the individual event from the resulting event lists does not contain the following key-value pair, then it is a finding. 
    
    \"realmId\" : [ APPROPRIATE REALM ID]
    \"userId\" : [ APPROPRIATE USER ID ]
    \"sessionId\" : [ APPROPRIATE SESSION ID ]
    \"ipAddress\" : [ APPROPRIATE IP ADDRESS ]
    
    Note: Enabling 'events', 'adminEvents' and 'adminEventsDetails', along with configuring 'eventsListeners' and 'enabledEventTypes',  configures Keycloak to audit login events, account creations, account updates, account deletions, and admin actions.
  "
  desc  "fix", "
    Configure Keycloak audit records to identify where the events occurred.
    
    To configure this setting using the Keycloak admin CLI, do the following from a privileged account:
    
    kcadm.sh update events/config -r [your realm] -s eventsEnabled=true -s eventsListeners=[\"jboss-logging\"] -s adminEventsEnabled=true -s adminEventsDetailsEnabled=true
    
    Note: Enabling 'events', 'adminEvents' and 'adminEventsDetails', along with configuring 'eventsListeners' and 'enabledEventTypes',  configures Keycloak to audit login events, account creations, account updates, account deletions, and admin actions.
  "
  impact 0.5
  tag severity: "medium"
  tag gtitle: "SRG-APP-000097-AAA-000240"
  tag gid: nil
  tag rid: nil
  tag stig_id: "KEYC-01-000013"
  tag cci: ["CCI-000132"]
  tag nist: ["AU-3"]
	
  test_command = "#{input('path')}kcadm.sh get events -r #{input('keycloak_realm')} | grep -E 'realmId|userId|sessionId|ipAddress'"

  describe command(test_command) do
	  # change these to check that they are not nil, or check that key exists
	  its('stdout') { should match(%r{"realmId" : "[0-9a-z]{8}-[0-9a-z]{4}-[0-9a-z]{4}-[0-9a-z]{4}-[0-9a-z]{12}"}) }
	  its('stdout') { should match(%r{"userId" : "[0-9a-z]{8}-[0-9a-z]{4}-[0-9a-z]{4}-[0-9a-z]{4}-[0-9a-z]{12}"}) }
	  its('stdout') { should match(%r{"sessionId" : "[0-9a-z]{8}-[0-9a-z]{4}-[0-9a-z]{4}-[0-9a-z]{4}-[0-9a-z]{12}"}) }
	  # its('stdout') { should include '"realmId" : "0137bc9e-7a66-44bb-8a20-dd1f01070ad2"' }
	  # its('stdout') { should include '"userId" : "d654175b-62b8-449e-9e8d-2b635db5d9e5"' }
	  # its('stdout') { should include '"sessionId" : "4d140156-d601-4a21-a4b2-9c707aae421f"' }
	  its('stdout') { should include '"ipAddress" : "127.0.0.1"' }
  end
end