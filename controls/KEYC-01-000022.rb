control 'KEYC-01-000022' do
  title 'Keycloak must be configured to use secure protocols when connecting to directory services.'
  desc  "
    Authenticity protection provides protection against man-in-the-middle attacks/session hijacking and the insertion of false information into sessions.

    Application communication sessions are protected utilizing transport encryption protocols, such as TLS. TLS provides a means to authenticate sessions and encrypt application traffic. Session authentication can be single (one-way) or mutual (two-way) in nature. Single authentication authenticates the server for the client, whereas mutual authentication provides a means for both the client and the server to authenticate each other.

    This requirement addresses communications protection at the application session, versus the network packet, and establishes grounds for confidence at both ends of communications sessions in ongoing identities of other parties and in the validity of information transmitted.
  "
  desc  'rationale', ''
  desc  'check', "
    If Keycloak do not connect to a directory services or other identity provider, but instead perform user and device account management as part of their functionality, this is not applicable.

    Review the Keycloak configuration when connecting to directory services or another identity provider. Verify the connection is configured to use secure protocols for transport between Keycloak and the directory services using mutual authentication. The use of LDAP over TLS (LDAPS) is the most common method to secure the directory services or user database traffic. Each protocol egressing the local enclave must be implemented in accordance with its PPSM CAL.

    If Keycloak do not use secure protocols when connecting to directory services, this is a finding. If the protocols are not implemented in accordance with the PPSM CAL, this is a finding.

    Check keycloak configuration file, conf/keycloak.conf. If the file does not contain the following key-value pairs, it is a finding.

    hostname-strict-https=true
    https-client-auth=required

    https-trust-store-file=[PATH TO TRUST STORE FILE]
    https-trust-store-password=[APPROPRIATE PASSWORD]

    And one of the below two cases:

    https-key-store-file=[PATH TO KEY STORE FILE]
    https-key-store-password=[APPROPRIATE PASSWORD]

    OR:

    https-certificate-file=[PATH TO CERTIFICATE]
    https-certificate-key-file=[PATH TO CERTIFICATE KEY]
  "
  desc 'fix', "
    Configure Keycloak to use secure protocols when connecting to directory services. The use of LDAP over TLS (LDAPS) is the most common method to secure the directory services or user database traffic. However, proprietary or other protocols may be used in some configurations. Each protocol egressing the local enclave must be implemented in accordance with its PPSM CAL.

    Create or update Keycloak with the following lines in your keycloak configuration file, conf/keycloak.conf:

    hostname-strict-https=true
    https-client-auth=required

    https-trust-store-file=[PATH TO TRUST STORE FILE]
    https-trust-store-password=[APPROPRIATE PASSWORD]

    And one of the below two cases:

    https-key-store-file=[PATH TO KEY STORE FILE]
    https-key-store-password=[APPROPRIATE PASSWORD]

    OR:

    https-certificate-file=[PATH TO CERTIFICATE]
    https-certificate-key-file=[PATH TO CERTIFICATE KEY]
  "
  impact 0.7
  tag severity: 'high'
  tag gtitle: 'SRG-APP-000142-AAA-000010'
  tag gid: nil
  tag rid: nil
  tag stig_id: 'KEYC-01-000022'
  tag cci: ['CCI-000382']
  tag nist: ['CM-7 b']

  if input('directory_services_for_acct_mgmt')

    describe parse_config_file('/opt/keycloak/conf/keycloak.conf') do
      its('hostname-strict-https') { should eq 'true' }
      its('https-client-auth') { should eq 'required' }
      its('https-trust-store-file') { should eq input('https_truststore_file_path') }
      its('https-trust-store-password') { should_not be nil }
    end

    describe.one do
      describe parse_config_file('/opt/keycloak/conf/keycloak.conf') do
        its('https-key-store-file') { should eq input('https_keystore_file_path') }
        its('https-key-store-password') { should_not be nil }
      end

      describe parse_config_file('/opt/keycloak/conf/keycloak.conf') do
        its('https-certificate-file') { should eq input('https_certificate_file_path') }
        its('https-certificate-key-file') { should eq input('https_certificate_key_path') }
      end
    end

  else
    impact 0.0
    describe 'Manual Check' do
      skip 'Keycloak does not rely on directory services for user account management. This control is not applicable.'
    end
  end
end
