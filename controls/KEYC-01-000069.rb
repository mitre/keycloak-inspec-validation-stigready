# -*- encoding : utf-8 -*-
control "KEYC-01-000069" do
  title "AAA Services must be configured in accordance with the security configuration settings based on DoD security configuration or implementation guidance, including STIGs, NSA configuration guides, CTOs, and DTMs."
  desc  "
    Configuring the application to implement organization-wide security implementation guides and security checklists ensures compliance with federal standards and establishes a common security baseline across DoD that reflects the most restrictive security posture consistent with operational requirements. 
    
    Configuration settings are the set of parameters that can be changed that affect the security posture and/or functionality of the system. Security-related parameters are those parameters impacting the security state of the application, including the parameters required to satisfy other security control requirements.
  "
  desc  "rationale", ""
  desc  "check", "
    Determine if AAA Services are configured in accordance with the security configuration settings based on DoD security configuration or implementation guidance, including STIGs, NSA configuration guides, CTOs, and DTMs.
    
    If AAA Services are not configured in accordance with the designated security configuration settings, this is a finding.
  "
  desc  "fix", "Configure the network device to be configured in accordance with the security configuration settings based on DoD security configuration or implementation guidance, including STIGs, NSA configuration guides, CTOs, and DTMs."
  impact 0.5
  tag severity: "medium"
  tag gtitle: "SRG-APP-000516-AAA-000690"
  tag gid: nil
  tag rid: nil
  tag stig_id: "KEYC-01-000069"
  tag cci: ["CCI-000366"]
  tag nist: ["CM-6 b"]
end