control 'KEYC-01-000017' do
  title 'Keycloak must be configured to alert the SA and ISSO when any audit processing failure occurs.'
  desc  "
    It is critical for the appropriate personnel to be aware if a system is at risk of failing to process audit logs as required. Without this notification, the security personnel may be unaware of an impending failure of the audit capability and system operation may be adversely affected.

    Audit processing failures include software/hardware errors, failures in the audit capturing mechanisms, and audit storage capacity being reached or exceeded.

    This requirement applies to each audit data storage repository (i.e., distinct information system component where audit records are stored), the centralized audit storage capacity of organizations (i.e., all audit data storage repositories combined), or both.
  "
  desc  'rationale', ''
  desc  'check', "
    Verify Keycloak are configured to alert the SA and ISSO when any audit processing failure occurs.

    If Keycloak are not configured to alert the SA and ISSO when any audit processing failure occurs, this is a finding.

    To confirm this setting is configured using the Keycloak admin CLI, after logging in with a privileged account, which can be done by running:

    kcadm.sh config credentials --server [server location] --realm master --user [username] --password [password]

    then run the following command:

    kcadm.sh get events/config -r [realm]

    If the results are not as follows, then it is a finding.

    \"eventsEnabled\" : true,
    \"eventsListeners\" : [ \"jboss-logging\" ],
    \"enabledEventTypes\" : [ APPROPRIATE EVENT TYPES ],

    Then check keycloak configuration file, conf/keycloak.conf. If the file does not contain the following key-value pairs, it is a finding.

    spi-events-listener-jboss-logging-success-level=info
    spi-events-listener-jboss-logging-error-level=error

    Then check quarkus configuration file, conf/quarkus.properties. If the file does not contain the following key-value pairs, it is a finding.

    quarkus.log.syslog.enable=true
    quarkus.log.syslog.endpoint=[APPROPRIATE ENDPOINT]
    quarkus.log.syslog.protocol=[APPROPRIATE PROTOCOL]

    Then verify syslog is configured to alert the SA and ISSO when any audit processing failure occurs. In a Unix-like system, confirm with:

    $ sudo grep '^action_mail_acct = root' /etc/audit/auditd.conf

    action_mail_acct = <administrator_account>

    If the value of the \"action_mail_acct\" keyword is not set to an accounts for security personnel, the \"action_mail_acct\" keyword is missing, or the returned line is commented out, this is a finding.
  "
  desc 'fix', "
    Configure Keycloak to alert the SA and ISSO when any audit processing failure occurs.

    To configure this setting using the Keycloak admin CLI, do the following from a privileged account:

    kcadm.sh update events/config -r [realm] -s eventsEnabled=true -s eventsListeners=[\"jboss-logging\"] -s adminEventsEnabled=true -s adminEventsDetailsEnabled=true

    Then create or update keycloak configuration file, conf/keycloak.conf:

    spi-events-listener-jboss-logging-success-level=info
    spi-events-listener-jboss-logging-error-level=error

    Then create or update quarkus configuration file, conf/quarkus.properties:

    quarkus.log.syslog.enable=true
    quarkus.log.syslog.endpoint=[APPROPRIATE ENDPOINT]
    quarkus.log.syslog.protocol=[APPROPRIATE PROTOCOL]

    Then, edit the following line in \"/etc/audit/auditd.conf\" in a Unix-like system to ensure administrators are notified via email for those situations:

    action_mail_acct = <administrator_account>

    Note: Change \"administrator_account\" to an account for security personnel.

    Restart the \"auditd\" service so the changes take effect:

    $ sudo systemctl restart auditd.service
  "
  impact 0.5
  tag severity: 'medium'
  tag gtitle: 'SRG-APP-000108-AAA-000290'
  tag gid: nil
  tag rid: nil
  tag stig_id: 'KEYC-01-000017'
  tag cci: ['CCI-000139']
  tag nist: ['AU-5 a']

  test_command = "#{input('executable_path')}kcadm.sh get events/config -r #{input('keycloak_realm')}"

  describe json(content: command(test_command).stdout) do
    its('eventsEnabled') { should eq true }
    #TODO: Should this be tested as below in case of other possible eventsListeners?
    its('eventsListeners') { should eq ['jboss-logging'] }
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

  describe parse_config_file('/opt/keycloak/conf/keycloak.conf') do
    its('spi-events-listener-jboss-logging-success-level') { should eq 'info' }
    its('spi-events-listener-jboss-logging-error-level') { should eq 'error' }
  end

  describe parse_config_file('/opt/keycloak/conf/quarkus.properties') do
    its(['quarkus.log.syslog.enable']) { should eq 'true' }
    its(['quarkus.log.syslog.endpoint']) { should eq input('quarkus_endpoint') }
    its(['quarkus.log.syslog.protocol']) { should eq input('quarkus_protocol') }
  end

  describe parse_config_file('/etc/audit/auditd.conf') do
    its(['action_mail_acct']) { should eq input('action_mail_account') }
  end

  if virtualization.system.eql?('docker')
    describe 'Manual review is required within a container' do
      skip "Verifying the host's configuration to alert the SA and ISSO when any audit processing failure occurs cannot be done within the container and should be reviewed manually."
    end
  else
    describe service('auditd') do
      it { should be_installed }
      it { should be_enabled }
      it { should be_running }
    end
    describe parse_config_file('/etc/audit/audid.conf') do
      its(['action_mail_acct']) { should eq input('action_mail_account') }
    end
  end
end
