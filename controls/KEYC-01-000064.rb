# -*- encoding : utf-8 -*-
control "KEYC-01-000064" do
  title "AAA Services must not be configured with shared accounts."
  desc  "Shared accounts configured for use on a network device do not allow for accountability or repudiation of individuals using them. If shared accounts are not changed when someone leaves the group, that person could possibly gain control of the network device. Having shared accounts does not allow for proper auditing of who is accessing or changing the network. For this reason, shared accounts are not permitted."
  desc  "rationale", ""
  desc  "check", "
    If Keycloak is configured to rely on directory services for user account management, this is Not Applicable and the connected directory services must perform this function.
    
    Determine if Keycloak is configured with shared accounts. Identify group profile definitions that do not meet the accounts user-id naming convention.
    
    Any shared account must be documented with the ISSO. Documentation must include the reason for the account, who has access to this account, and how the risk of using a shared account (which provides no individual identification and accountability) is mitigated. Determine if this documentation is validated at an agreed-upon frequency defined by the system owner and ISSO.
    
    If Keycloak is configured with shared accounts (group profiles) that are not documented with the ISSO, or the documentation on shared accounts is not current, this is a Finding.
  "
  desc  "fix", "Remove all shared accounts that are not documented with the ISSO and validated on the agreed-upon frequency defined by the system owner and ISSO."
  impact 0.5
  tag severity: "medium"
  tag gtitle: "SRG-APP-000516-AAA-000620"
  tag gid: nil
  tag rid: nil
  tag stig_id: "KEYC-01-000064"
  tag cci: ["CCI-000366"]
  tag nist: ["CM-6 b"]
end