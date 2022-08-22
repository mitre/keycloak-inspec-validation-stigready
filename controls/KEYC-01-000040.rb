# -*- encoding : utf-8 -*-
control "KEYC-01-000040" do
  title "Keycloak must be configured to only accept certificates issued by a DoD-approved Certificate Authority for PKI-based authentication."
  desc  "
    Without path validation, an informed trust decision by the relying party cannot be made when presented with any certificate not already explicitly trusted.
    
    A trust anchor is an authoritative entity represented via a public key and associated data. It is used in the context of public key infrastructures, X.509 digital certificates, and DNSSEC. 
    
    When there is a chain of trust, usually the top entity to be trusted becomes the trust anchor; it can be, for example, a Certification Authority (CA). A certification path starts with the subject certificate and proceeds through a number of intermediate certificates up to a trusted root certificate, typically issued by a trusted CA. 
    
    This requirement verifies that a certification path to an accepted trust anchor is used to for certificate validation and that the path includes status information. Path validation is necessary for a relying party to make an informed trust decision when presented with any certificate not already explicitly trusted. Status information for certification paths includes certificate revocation lists or online certificate status protocol responses.
  "
  desc  "rationale", ""
  desc  "check", "
    Verify AAA Services are configured to only accept certificates issued by a DoD-approved Certificate Authority for PKI-based authentication.
    
    If AAA Services are not configured to only accept certificates issued by a DoD-approved Certificate Authority, this is a finding.
  "
  desc  "fix", "Configure AAA Services to only accept certificates issued by a DoD-approved Certificate Authority for PKI-based authentication."
  impact 0.7
  tag severity: "high"
  tag gtitle: "SRG-APP-000175-AAA-000570"
  tag gid: nil
  tag rid: nil
  tag stig_id: "KEYC-01-000040"
  tag cci: ["CCI-000185"]
  tag nist: ["IA-5 (2) (a)"]
end