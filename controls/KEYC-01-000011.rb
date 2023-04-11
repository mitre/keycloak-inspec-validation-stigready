control 'KEYC-01-000011' do
  title 'Keycloak configuration audit records must identify what type of events occurred.'
  desc  "
    Without establishing what type of event occurred, it would be difficult to establish, correlate, and investigate the events relating to an incident, or identify those responsible for one.

    Audit record content that may be necessary to satisfy the requirement of this policy includes, for example, time stamps, source and destination addresses, user/process identifiers, event descriptions, success/fail indications, filenames involved, and access control or flow control rules invoked.

    Associating event types with detected events in the application and audit logs provides a means of investigating an attack; recognizing resource utilization or capacity thresholds; or identifying an improperly configured application.
  "
  desc  'rationale', ''
  desc  'check', "
    Verify Keycloak configuration audit records identify what type of events occurred.

    If Keycloak configuration audit records do not identify what type of events occurred, this is a finding.

    Keycloak's event logging feature will record an event type for each event. To check if Keycloak is configured for event logging, log in with a privileged account from the CLI:

    kcadm.sh config credentials --server [server location] --realm master --user [username] --password [password]

    then run the following command:

    kcadm.sh get events/config -r [realm]

    If the results do not include the following values, then this is a finding.

    \"eventsEnabled\" : true,
    \"eventsListeners\" : [ \"jboss-logging\" ],
    \"adminEventsEnabled\" : true,
    \"adminEventsDetailsEnabled\" : true

    Then run the command:

    kcadm.sh get events

    If the individual events from the resulting event list do not contain the following key-value pairs, then this is a finding.

    \"type\" : [event types]

    Note: Enabling 'events', 'adminEvents' and 'adminEventsDetails', along with configuring 'eventsListeners' and 'enabledEventTypes',  configures Keycloak to audit login events, account creations, account updates, account deletions, and admin actions.
  "
  desc 'fix', "
    Configure Keycloak audit records to identify what type of events occurred.

    To configure this setting using the Keycloak admin CLI, do the following from a privileged account:

    kcadm.sh update events/config -r [realm] -s eventsEnabled=true -s eventsListeners=[\"jboss-logging\"] -s adminEventsEnabled=true -s adminEventsDetailsEnabled=true

    Note: Enabling 'events', 'adminEvents' and 'adminEventsDetails', along with configuring 'eventsListeners' and 'enabledEventTypes',  configures Keycloak to audit login events, account creations, account updates, account deletions, and admin actions.
  "
  impact 0.5
  tag severity: 'medium'
  tag gtitle: 'SRG-APP-000095-AAA-000220'
  tag gid: nil
  tag rid: nil
  tag stig_id: 'KEYC-01-000011'
  tag cci: ['CCI-000130']
  tag nist: ['AU-3']

  test_command = "#{input('executable_path')}kcadm.sh get events/config -r #{input('keycloak_realm')}"

  describe json(content: command(test_command).stdout) do
    its('eventsEnabled') { should eq true }
    # TODO: Should this be tested as below in case of other possible eventsListeners?
    its('eventsListeners') { should eq ['jboss-logging'] }
    its('adminEventsEnabled') { should eq true }
    its('adminEventsDetailsEnabled') { should eq true }
  end

  # TODO: ensure user is aware that more enabledEventTypes can be added, this is a minimum
  describe 'JSON content' do
    it 'enabledEventTypes is expected to include enabled_event_types listed in inspec.yml' do
      actual_events_enabled = json(content: command(test_command).stdout)['enabledEventTypes']
      missing = actual_events_enabled - input('enabled_event_types')
      failure_message = "The generated JSON output does not include: #{missing}"
      expect(missing).to be_empty, failure_message
    end
  end
end
