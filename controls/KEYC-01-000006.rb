control 'KEYC-01-000006' do
  title 'Keycloak must be configured to automatically audit account modification.'
  desc  'Once an attacker establishes access to a system, the attacker often attempts to create a persistent method of reestablishing access. One way to accomplish this is for the attacker to simply modify an existing account. Auditing of account modification is one method for mitigating this risk. A comprehensive account management process will ensure an audit trail documents the modification of user accounts and, as required, notifies administrators and/or managers. Such a process greatly reduces the risk that accounts will be surreptitiously modified and provides logging that can be used for forensic purposes.'
  desc  'rationale', ''
  desc  'check', "
    If Keycloak relies on directory services for user account management, this is not applicable and the connected directory services must perform this function.

    Verify Keycloak is configured to automatically audit account modification.

    If Keycloak is not configured to automatically audit account modification, this is a finding.

    To check if Keycloak is configured to audit account modification, log into the Keycloak admin CLI with a privileged account:

    kcadm.sh config credentials --server [server location] --realm master --user [username] --password [password]

    Then run the following command:

    kcadm.sh get events/config -r [realm]

    \"eventsEnabled\" : true,
    \"eventsListeners\" : [ \"jboss-logging\" ],
    \"enabledEventTypes\" : [<list of other event types..>, \"UPDATE_PROFILE\", \"UPDATE_PROFILE\", \"UPDATE_EMAIL\", \"UPDATE_PASSWORD\"]
    \"adminEventsEnabled\" : true,
    \"adminEventsDetailsEnabled\" : true

    If the 'enabledEventTypes' field does not include the options \"UPDATE_PROFILE\", \"UPDATE_EMAIL\", and \"UPDATE_PASSWORD\", this is a finding.

    Note: Enabling 'events', 'adminEvents' and 'adminEventsDetails', along with configuring 'eventsListeners' and 'enabledEventTypes',  configures Keycloak to audit login events, account creations, account updates, account deletions, and admin actions.

  "
  desc 'fix', "
    Configure Keycloak to automatically audit account modification.

    To configure this setting using the Keycloak admin CLI, do the following from a privileged account:

    First, find the current enabled event types:

    kcadm.sh get events/config -r [realm] | grep enabledEventTypes

    Then update the configuration:

    kcadm.sh update events/config -r [realm] -s adminEventsEnabled=true -s adminEventsDetailsEnabled=true -s eventsEnabled=true -s 'eventsListeners=[\"jboss-logging\"] -s enabledEventTypes=\"[<list of other event types..>, \"UPDATE_PROFILE\", \"UPDATE_PROFILE\", \"UPDATE_EMAIL\", \"UPDATE_PASSWORD\"]\"

    Note: Enabling 'events', 'adminEvents' and 'adminEventsDetails', along with configuring 'eventsListeners' and 'enabledEventTypes',  configures Keycloak to audit login events, account creations, account updates, account deletions, and admin actions.
  "
  impact 0.5
  tag severity: 'medium'
  tag gtitle: 'SRG-APP-000027-AAA-000100'
  tag gid: nil
  tag rid: nil
  tag stig_id: 'KEYC-01-000006'
  tag cci: ['CCI-001403']
  tag nist: ['AC-2 (4)']

  if input('directory_services_for_acct_mgmt')
    impact 0.0
    describe 'Manual Check' do
      skip 'Keycloak relies on directory services for user account management. This control is not applicable.'
    end
  else

    test_command = "#{input('executable_path')}kcadm.sh get events/config -r #{input('keycloak_realm')}"

    describe json(content: command(test_command).stdout) do
      its('eventsEnabled') { should eq true }
      #TODO: Should this be tested as below in case of other possible eventsListeners?
      its('eventsListeners') { should eq ['jboss-logging'] }
      its('enabledEventTypes') { should include 'UPDATE_PROFILE' }
      its('enabledEventTypes') { should include 'UPDATE_EMAIL' }
      its('enabledEventTypes') { should include 'UPDATE_PASSWORD' }
      its('adminEventsEnabled') { should eq true }
      its('adminEventsDetailsEnabled') { should eq true }
    end

  end
end
