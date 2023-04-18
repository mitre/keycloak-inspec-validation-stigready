# Uncomment the below lines to add gems and files required by the resource
# require ""
# require_relative ""

# Change module if required
module Inspec::Resources
  # Most custom InSpec resource inherit from a dynamic class, InSpec.resource(1).
  # If you wish to inherit from a core resource, you need to follow special instructions -
  # see https://www.chef.io/blog/extending-inspec-resources-core-resource-inheritance
  class KeycloakRealm < Inspec.resource(1)
    # Every resource requires an internal name.
    name "keycloak_realm"

    # Restrict to only run on the below platforms (if none were given,
    # all OS's and cloud API's supported)
    supports platform: "linux"

    desc "Keycloak Realm"

    example <<~EXAMPLE
      describe "keycloak_realm" do
        its("shoe_size") { should cmp 10 }
      end
      describe "keycloak_realm" do
        it { should be_purple }
      end
    EXAMPLE

    # Resource initialization. Add any arguments you want to pass to the contructor here.
    # Anything you pass here will be passed to the "describe" call:
    # describe keycloak_realm(YOUR_PARAMETERS_HERE) do
    #   its("shoe_size") { should cmp 10 }
    # end
    def initialize()

    end

    # Define how you want your resource to appear in test reports. Commonly, this is just the resource name and the resource ID.
    def to_s
      "keycloak_realm"
    end

    def event_config(realm)

      inspec.keycloak.event_config(realm)

      # # command = "/opt/keycloak/bin/kcadm.sh get events/config --no-config --server http://localhost:8080 --realm master --user admin --password admin"
      # command = "#{@kcadm_path} get events/config -r #{@realm} --no-config --server http://localhost:8080 --realm master --user #{@keycloak_admin} --password #{@keycloak_admin_password}"
      # # binding.pry
      # inspec.json(content: inspec.command(command).stdout)
    end
  end
end
