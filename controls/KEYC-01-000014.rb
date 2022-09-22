# -*- encoding : utf-8 -*-
control "KEYC-01-000014" do
  title "Keycloak configuration audit records must identify the source of the events."
  desc  "
    Without establishing the source of the event, it is impossible to establish, correlate, and investigate the events leading up to an outage or attack.
    
    In addition to logging where events occur within the application, the application must also produce audit records that identify the application itself as the source of the event.
    
    In the case of centralized logging, the source would be the application name accompanied by the host or client name. 
    
    In order to compile an accurate risk assessment, and provide forensic analysis, it is essential for security personnel to know the source of the event, particularly in the case of centralized logging.
    
    Associating information about the source of the event within the application provides a means of investigating an attack; recognizing resource utilization or capacity thresholds; or identifying an improperly configured application.
  "
  desc  "rationale", ""
  desc  "check", "
    Verify Keycloak configuration audit records identify the source of the events.
    
    If Keycloak configuration audit records do not identify the source of the events, this is a finding.
    
    Keycloak's event logging feature will record the source application that generated each event via the client ID. To check if Keycloak is configured for event logging, log into the Keycloak admin CLI with a privileged account:
    
    kcadm.sh config credentials --server [server location] --realm master --user [username] --password [password]
    
    Then run the following commands:
    
    kcadm.sh get events/config -r [realm]
    
    If the results do not include the following values, then this is a finding.
    
    \"eventsEnabled\" : true,
    \"eventsListeners\" : [ \"jboss-logging\" ],
    \"adminEventsEnabled\" : true,
    \"adminEventsDetailsEnabled\" : true
    
    Note: Enabling 'events', 'adminEvents' and 'adminEventsDetails', along with configuring 'eventsListeners',  configures Keycloak to audit login events, account creations, account updates, account deletions, and admin actions.
  "
  desc  "fix", "
    Configure Keycloak configuration audit records to identify the source of the events.
    
    To configure this setting using the Keycloak admin CLI, do the following from a privileged account:
    
    kcadm.sh update events/config -r [realm] -s adminEventsEnabled=true -s adminEventsDetailsEnabled=true -s eventsEnabled=true -s 'eventsListeners=[\"jboss-logging\"]'
    
    Note: Enabling 'events', 'adminEvents' and 'adminEventsDetails', along with configuring 'eventsListeners',  configures Keycloak to audit login events, account creations, account updates, account deletions, and admin actions.
  "
  impact 0.5
  tag severity: "medium"
  tag gtitle: "SRG-APP-000098-AAA-000250"
  tag gid: nil
  tag rid: nil
  tag stig_id: "KEYC-01-000014"
  tag cci: ["CCI-000133"]
  tag nist: ["AU-3"]

  test_command = "#{input('executable_path')}kcadm.sh get events/config -r #{input('keycloak_realm')}"

  describe json(content: command(test_command).stdout) do
	  its('eventsEnabled') { should eq true }
	  # TODO: Should this be tested as below in case of other possible eventsListeners?
	  its('eventsListeners') { should eq ["jboss-logging"] }
	  its('adminEventsEnabled') { should eq true }
	  its('adminEventsDetailsEnabled') { should eq true }
  end

  # describe 'JSON content' do
  #   it 'eventsListeners is expected to include events_listeners listed in inspec.yml' do
  # 	  actual_events_listeners = json(content: command(test_command).stdout)['eventsListeners']
  # 	  missing = actual_events_listeners - input('events_listeners')
  # 	  failure_message = "The generated JSON output does not include: #{missing}"
  # 	  expect(missing).to be_empty, failure_message
  #   end
  # end
end