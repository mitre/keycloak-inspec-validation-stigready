control 'KEYC-01-000018' do
  title 'Keycloak must be configured to generate audit records overwriting the oldest audit records in a first-in-first-out manner.'
  desc  "
    It is critical that when Keycloak are at risk of failing to process audit logs as required, they take action to mitigate the failure. Audit processing failures include software/hardware errors, failures in the audit capturing mechanisms, and audit storage capacity being reached or exceeded. Responses to audit failure depend upon the nature of the failure mode.

    For Keycloak, availability is an overriding concern, and so both of the following approved actions in response to an audit failure must be met:

    (i) If the failure was caused by the lack of audit record storage capacity, Keycloak must continue generating audit records if possible (automatically restarting the audit service if necessary), overwriting the oldest audit records in a first-in-first-out manner.
    (ii) If audit records are sent to a centralized collection server and communication with this server is lost or the server fails, Keycloak must queue audit records locally until communication is restored or until the audit records are retrieved manually. Upon restoration of the connection to the centralized collection server, action should be taken to synchronize the local audit data with the collection server.
  "
  desc  'rationale', ''
  desc  'check', "
    Verify Keycloak is configured to generate audit records overwriting the oldest audit records in a first-in-first-out manner. When failures are caused by the lack of audit record storage capacity, Keycloak must continue generating audit records.

    If Keycloak is not configured to generate audit records overwriting the oldest audit records in a first-in-first-out manner, this is a finding.

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

    Then check that the log service is enabled on the system with the following command:

    systemctl is-enabled rsyslog

    If the command above returns \"disabled\", this is a finding.

    Check that the log service is properly running and active on the system with the following command:

    systemctl is-active rsyslog

    If the command above returns \"inactive\", this is a finding.

    Confirm with the centralized server's administrators that audit records are configured to be overwritten in a first-in-first-out manner. If audit records are not configured to be overwritten in a first-in-first-out manner, this is a finding.
  "
  desc 'fix', "
    Configure Keycloak to generate audit records overwriting the oldest audit records in a first-in-first-out manner. Some specific implementations may further require automatically restarting the audit service to synchronize the local audit data with the collection server. The configuration must continue generating audit records, even when failures are caused by the lack of audit record storage capacity.

    To configure this setting using the Keycloak admin CLI, do the following from a privileged account:

    kcadm.sh update events/config -r [realm] -s eventsEnabled=true -s eventsListeners=[\"jboss-logging\"] -s adminEventsEnabled=true -s adminEventsDetailsEnabled=true

    Then create or update keycloak configuration file, conf/keycloak.conf:

    spi-events-listener-jboss-logging-success-level=info
    spi-events-listener-jboss-logging-error-level=error

    Then create or update quarkus configuration file, conf/quarkus.properties:

    quarkus.log.syslog.enable=true
    quarkus.log.syslog.endpoint=[APPROPRIATE ENDPOINT]
    quarkus.log.syslog.protocol=[APPROPRIATE PROTOCOL]

    Then install the log service (if the log service is not already installed) on system with the following command:

    sudo apt-get install rsyslog

    Enable the log service with the following command:

    sudo systemctl enable --now rsyslog

    Work with the centralized server's administrators to configure audit records to overwrite oldest records in a first-in-first-out manner.
  "
  impact 0.5
  tag severity: 'medium'
  tag gtitle: 'SRG-APP-000109-AAA-000300'
  tag gid: nil
  tag rid: nil
  tag stig_id: 'KEYC-01-000018'
  tag cci: ['CCI-000140']
  tag nist: ['AU-5 b']

  test_command = "#{input('executable_path')}kcadm.sh get events/config -r #{input('keycloak_realm')}"

  describe json(content: command(test_command).stdout) do
    its('eventsEnabled') { should eq true }
    # TODO: Should this be tested as below in case of other possible eventsListeners?
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

  if virtualization.system.eql?('docker')
    describe 'Manual review is required within a container' do
      skip 'Installing the log service on system cannot be done within the container and should be reviewed manually.'
    end
  else
    describe service('rsyslog') do
      it { should be_installed }
      it { should be_enabled }
      it { should be_running }
    end
  end
  describe 'Configure audit records' do
    skip 'Ensuring audit records are configured to overwrite in a first-in-first-out manner should be reviewed manually.'
  end
end
