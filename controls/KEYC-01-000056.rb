# -*- encoding : utf-8 -*-
control "KEYC-01-000056" do
  title "Keycloak must be configured to use or map to Coordinated Universal Time (UTC) to record time stamps for audit records."
  desc  "
    If time stamps are not consistently applied and there is no common time reference, it is difficult to perform forensic analysis.
    
    Time stamps generated by the application include date and time. Time is commonly expressed in Coordinated Universal Time (UTC) or local time with an offset from UTC.
  "
  desc  "rationale", ""
  desc  "check", "
    Verify Keycloak are configured to use or map to UTC to record time stamps for audit records. The audit records must either show UTC time or an offset to UTC time for each entry.
    
    If Keycloak are not configured to use or map to UTC to record time stamps for audit records, this is a finding.
    
    To confirm this setting is configured using the Keycloak admin CLI, after logging in with a privileged account, which can be done by running:
    
    kcadm.sh config credentials --server [server location] --realm master --user [username] --password [password]
    
    then run the following command:
    
    kcadm.sh get events/config -r [realm]
    
    If the results are not as follows, then it is a finding.
    
    \"eventsEnabled\" : true, 
    \"eventsListeners\" : [ \"jboss-logging\" ],
    \"enabledEventTypes\" : [ APPROPRIATE EVENT TYPES ],
    \"adminEventsEnabled\" : true,
    \"adminEventsDetailsEnabled\" : true
    
    Then check keycloak configuration file, conf/keycloak.conf. If the file does not contain the following key-value pairs, it is a finding.
    
    spi-events-listener-jboss-logging-success-level=info
    spi-events-listener-jboss-logging-error-level=error
    
    Then check quarkus configuration file, conf/quarkus.properties. If the file does not contain the following key-value pairs, it is a finding.
    
    quarkus.log.syslog.enable=true
    quarkus.log.syslog.endpoint=[APPROPRIATE ENDPOINT]
    quarkus.log.syslog.protocol=[APPROPRIATE PROTOCOL]
    quarkus.log.syslog.format=\"%z{UTC OR AN OFFSET TO UTC} [OTHER FORMATTING SYMBOLS]\"
    
    Then check that the log service is enabled on the system with the following command:
    
    systemctl is-enabled rsyslog
    
    If the command above returns \"disabled\", this is a finding.
    
    Check that the log service is properly running and active on the system with the following command:
    
    systemctl is-active rsyslog
    
    If the command above returns \"inactive\", this is a finding.
  "
  desc  "fix", "
    Configure Keycloak to use or map to UTC to record time stamps for audit records.
    
    To configure this setting using the Keycloak admin CLI, do the following from a privileged account:
    
    kcadm.sh update events/config -r [realm] -s eventsEnabled=true -s eventsListeners=[\"jboss-logging\"] -s adminEventsEnabled=true -s adminEventsDetailsEnabled=true
    
    Then create or update Keycloak logging format with the following line in your keycloak configuration file, conf/keycloak.conf:
    
    spi-events-listener-jboss-logging-success-level=info
    spi-events-listener-jboss-logging-error-level=error
    
    Then create or update quarkus configuration file, conf/quarkus.properties:
    
    quarkus.log.syslog.enable=true
    quarkus.log.syslog.endpoint=[APPROPRIATE ENDPOINT]
    quarkus.log.syslog.protocol=[APPROPRIATE PROTOCOL]
    quarkus.log.syslog.format=\"%z{UTC} [OTHER FORMATTING SYMBOLS]\"
    
    Then install the log service (if the log service is not already installed) on system with the following command:
    
    sudo apt-get install rsyslog
    
    Enable the log service with the following command:
    
    sudo systemctl enable --now rsyslog
  "
  impact 0.5
  tag severity: "medium"
  tag gtitle: "SRG-APP-000374-AAA-000340"
  tag gid: nil
  tag rid: nil
  tag stig_id: "KEYC-01-000056"
  tag cci: ["CCI-001890"]
  tag nist: ["AU-8 b"]

  test_command = "#{input('executable_path')}kcadm.sh get events/config -r #{input('keycloak_realm')}"

  describe json(content: command(test_command).stdout) do
	  its('eventsEnabled') { should eq true }
	  # TODO: Should this be tested as below in case of other possible eventsListeners?
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

  # describe 'JSON content' do
  #   it 'eventsListeners is expected to include events_listeners listed in inspec.yml' do
  # 	  actual_events_listeners = json(content: command(test_command).stdout)['eventsListeners']
  # 	  missing = actual_events_listeners - input('events_listeners')
  # 	  failure_message = "The generated JSON output does not include: #{missing}"
  # 	  expect(missing).to be_empty, failure_message
  #   end
  # end

  describe parse_config_file('/opt/keycloak/conf/keycloak.conf') do
	  its('spi-events-listener-jboss-logging-success-level') { should eq 'info' }
	  its('spi-events-listener-jboss-logging-error-level') { should eq 'error' }
  end

  describe parse_config_file('/opt/keycloak/conf/quarkus.properties') do
	  its(['quarkus.log.syslog.enable']) { should eq 'true' }
	  its(['quarkus.log.syslog.endpoint']) { should eq input('quarkus_endpoint') }
	  its(['quarkus.log.syslog.protocol']) { should eq input('quarkus_protocol') }
	  its(['quarkus.log.syslog.format']) { should eq input('quarkus_format') }
  end

  # TODO: "systemctl is-enabled rsyslog" and "systemctl is-active rsyslog" are a no-go. Solutions?
end