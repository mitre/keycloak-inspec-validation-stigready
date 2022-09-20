# -*- encoding : utf-8 -*-
control "KEYC-01-000015" do
  title "Keycloak configuration audit records must identify the outcome of the events."
  desc  "
    Without information about the outcome of events, security personnel cannot make an accurate assessment as to whether an attack was successful or if changes were made to the security state of the system.
    
    Event outcomes can include indicators of event success or failure and event-specific results (e.g., the security state of the information system after the event occurred). As such, they also provide a means to measure the impact of an event and help authorized personnel to determine the appropriate response.
  "
  desc  "rationale", ""
  desc  "check", "
    Verify Keycloak configuration audit records identify the outcome of the events.
    
    If Keycloak configuration audit records do not identify the outcome of the events, this is a finding.
    
    The outcome of an auditable event can be seen by examining the Keycloak event log. Ensure that the event log is enabled, and configured to capture the appropriate events. To check if Keycloak is configured for event logging, log into the Keycloak admin CLI with a privileged account:
    
    kcadm.sh config credentials --server [server location] --realm master --user [username] --password [password]
    
    then run the following command:
    
    kcadm.sh get events/config -r [realm]
    
    If the results do not include the following values, then this is a finding.
    
    \"eventsEnabled\" : true, 
    \"eventsListeners\" : [ \"jboss-logging\" ],
    \"adminEventsEnabled\" : true,
    \"adminEventsDetailsEnabled\" : true
    
    Then run the command: 
    
    kcadm.sh get events -r [realm]
    
    If the individual events from the resulting event list do not contain the following key-value pairs, then this is a finding.
    
    \"type\" : [type]
  "
  desc  "fix", "
    Configure Keycloak configuration audit records to identify the outcome of the events.
    
    To configure this setting using the Keycloak admin CLI, do the following from a privileged account:
    
    kcadm.sh update events/config -r [realm] -s eventsEnabled=true -s 'eventsListeners=[\"jboss-logging\"]' -s adminEventsEnabled=true -s adminEventsDetailsEnabled=true
  "
  impact 0.5
  tag severity: "medium"
  tag gtitle: "SRG-APP-000099-AAA-000260"
  tag gid: nil
  tag rid: nil
  tag stig_id: "KEYC-01-000015"
  tag cci: ["CCI-000134"]
  tag nist: ["AU-3"]

  test_command = "#{input('executable_path')}kcadm.sh get events/config -r #{input('keycloak_realm')}"

  describe json(content: command(test_command).stdout) do
	  its('eventsEnabled') { should eq true }
	  its('eventsListeners') { should eq ["jboss-logging"] }
	  its('adminEventsEnabled') { should eq true }
	  its('adminEventsDetailsEnabled') { should eq true }
  end

  # comment that more enabledEventTypes can be added, this is a minimum
  describe 'JSON content' do
	  it 'enabledEventTypes is expected to include enabled_event_types listed in inspec.yml' do
		  actual_events_enabled = json(content: command(test_command).stdout)['enabledEventTypes']
		  missing = actual_events_enabled - input('enabled_event_types')
		  failure_message = "The generated JSON output does not include: #{missing}"
		  expect(missing).to be_empty, failure_message
	  end
  end
end