# -*- encoding : utf-8 -*-
control "KEYC-01-000017" do
  title "AAA Services must be configured to alert the SA and ISSO when any audit processing failure occurs."
  desc  "
    It is critical for the appropriate personnel to be aware if a system is at risk of failing to process audit logs as required. Without this notification, the security personnel may be unaware of an impending failure of the audit capability and system operation may be adversely affected. 
    
    Audit processing failures include software/hardware errors, failures in the audit capturing mechanisms, and audit storage capacity being reached or exceeded.
    
    This requirement applies to each audit data storage repository (i.e., distinct information system component where audit records are stored), the centralized audit storage capacity of organizations (i.e., all audit data storage repositories combined), or both.
  "
  desc  "rationale", ""
  desc  "check", "
    Verify AAA Services are configured to alert the SA and ISSO when any audit processing failure occurs.
    
    If AAA Services are not configured to alert the SA and ISSO when any audit processing failure occurs, this is a finding.
  "
  desc  "fix", "Configure AAA Services to alert the SA and ISSO when any audit processing failure occurs."
  impact 0.5
  tag severity: "medium"
  tag gtitle: "SRG-APP-000108-AAA-000290"
  tag gid: nil
  tag rid: nil
  tag stig_id: "KEYC-01-000017"
  tag cci: ["CCI-000139"]
  tag nist: ["AU-5 a"]
end