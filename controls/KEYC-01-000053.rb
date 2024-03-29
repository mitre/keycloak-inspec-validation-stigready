control 'KEYC-01-000053' do
  title 'Keycloak must be configured to use Role-Based Access Control (RBAC) policy for levels of access authorization.'
  desc  "
    RBAC is an access control policy that restricts information system access to authorized users. Without these security policies, access control and enforcement mechanisms will not prevent unauthorized access.

    Organizations can create specific roles based on job functions and the authorizations (i.e., privileges) to perform needed operations on organizational information systems associated with the organization-defined roles. When users are assigned to the organizational roles, they inherit the authorizations or privileges defined for those roles. RBAC simplifies privilege administration for organizations because privileges are not assigned directly to every user (which can be a significant number of individuals for mid- to large-size organizations) but are instead acquired through role assignments. RBAC can be implemented either as a mandatory or discretionary form of access control.
  "
  desc  'rationale', ''
  desc  'check', "
    Verify Keycloak are configured to use RBAC policy for levels of access authorization. Confirm the RBAC groups have tiered privileges, and users are in the appropriate groups. In the following TACACS+ example the user (test-user) is a member of the group “test-group”.

    <CSUserver>$/opt/ciscosecure/CLI/ViewProfile -p 9900 -u user-test
    User Profile Information
    user = test-user{
    profile_id = 66
    profile_cycle = 1
    member = test-group
    password = des \"********\"
    }

    Below is an example of CiscoSecure TACACS+ server defining the privilege level.
    user = test-user{
     password = clear \"xxxxx\"
     service = shell {
     set priv-lvl = 7
     }
    }

    If Keycloak are not configured to use RBAC policy for levels of access authorization, this is a finding.

    To confirm this setting is configured using the Keycloak admin CLI, after logging in with a privileged account, which can be done by running:

    kcadm.sh config credentials --server [server location] --realm master --user [username] --password [password]

    then run the following command:

    kcadm.sh get-roles -r [YOUR REALM]
    kcadm.sh get-roles -r [YOUR REALM] --effective --uusername [USER NAME]

    If the command returns with any empty string or null, this is a finding.
    If the user does not have the appropriate roles(i.e. appropriate privileges), this is a finding.
  "
  desc 'fix', "
    Configure Keycloak to use RBAC policy for levels of access authorization. Configure Keycloak with standard accounts and assign them to privilege levels that meet their job description.

    To configure this settings using the Keycloak admin CLI, do the following from a privileged account:
    First, find the current setting for RBAC policy:

    kcadm.sh get-roles -r [YOUR REALM]
    kcadm.sh get-roles -r [YOUR REALM] --effective --uusername [USER NAME]

    Next, create RBAC policy, and add users to such policy, with the following commands:

    kcadm.sh create roles -r [YOUR REALM] -s name=[ROLE POLICY NAME] -s 'description=[ROLE POLICY DESCRIPTION LIMITING USER PERMISSIONS]'
    kcadm.sh add-roles --uusername [USER NAME] --rolename [ROLE POLICY NAME] -r [YOUR REALM]
  "
  impact 0.3
  tag severity: 'low'
  tag gtitle: 'SRG-APP-000329-AAA-000190'
  tag gid: nil
  tag rid: nil
  tag stig_id: 'KEYC-01-000053'
  tag cci: ['CCI-002169']
  tag nist: ['AC-3 (7)']

  #TODO: needs testing
  describe 'Current Roles' do
    test_command = "#{input('executable_path')}kcadm.sh get-roles -r #{input('keycloak_realm')}"

    it 'roles are expected to include only those listed in inspec.yml' do
      roles = json(content: command(test_command).stdout)
      actual_roles = roles.params.select { |key, _value| key == 'name' }
      unexpected_actual_roles = actual_roles.values - input('roles')
      failure_message = "The following roles were found, but are not listed in inspec.yml: #{unexpected_actual_roles}"
      expect(unexpected_actual_roles).to be_empty, failure_message
    end
  end
end
