# Uncomment the below lines to add gems and files required by the resource
require "keycloak"
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
    def initialize(realm)
      skip_resource "The `keycloak_realm` resource is not yet available on your OS." unless inspec.os.linux?
      @realm = realm
      # Initialize required path/params/configs
      # binding.pry
      # Initialize required path/params/configs
      keycloak_home = inspec.os_env("KEYCLOAK_HOME").content
      @keycloak_admin = inspec.os_env("KEYCLOAK_ADMIN").content
      @keycloak_admin_password = inspec.os_env("KEYCLOAK_ADMIN_PASSWORD").content
      # binding.pry
      if @keycloak_admin.nil? || @keycloak_admin.empty?
        raise Inspec::Exceptions::ResourceFailed, 'Failing because $KEYCLOAK_ADMIN env value not set or empty in the system'
      end

      if @keycloak_admin_password.nil? || @keycloak_admin_password.empty?
        raise Inspec::Exceptions::ResourceFailed, 'Failing because $KEYCLOAK_ADMIN_PASSWORD env value not set or empty in the system'
      end

      if keycloak_home.nil? || keycloak_home.empty?
        warn "$KEYCLOAK_HOME env value not set in the system"
        keycloak_home = '/opt/keycloak' if inspec.directory.('/opt/keycloak').exists?
        nil
      else
        @kcadm_path = "#{keycloak_home}/bin/kcadm.sh"
        if !inspec.file(@kcadm_path).exist?
          warn "No keycloak admin script found in $KEYCLOAK_HOME/bin/kcadm.sh"
          nil
        else
          @kcadm_path = @kcadm_path
        end
      end
      # binding.pry
    end

    # Define a resource ID. This is used in reporting engines to uniquely identify the individual resource.
    # This might be a file path, or a process ID, or a cloud instance ID. Only meaningful to the implementation.
    # Must be a string. Defaults to the empty string if not implemented.
    def resource_id
      # replace value specific unique to this individual resource instance
      "something special"
    end

    # Define how you want your resource to appear in test reports. Commonly, this is just the resource name and the resource ID.
    def to_s
      "keycloak_realm #{resource_id}"
    end

    # Define matchers. Matchers are predicates - they return true or false.
    # Matchers also have their names transformed: the question mark is dropped, and
    # the "is_" prefix becomes "be_". A similar transformation happens for "has_" (see below)
    # So this will be called as:
    #  describe "keycloak_realm" do
    #    it { should be_purple }
    #  end
    def is_purple?
      # positive or negative expectations specific to this resource instance
      true # Purple is the best color
    end

    # Define matchers. Matchers are predicates - they return true or false.
    # Matchers also have their names transformed: the question mark is dropped, and
    # the "has_" prefix becomes "have_".
    # So this will be called as:
    #  describe "keycloak_realm" do
    #    it { should have_bells }
    #  end
    def has_bells?
      # positive or negative expectations specific to this resource instance
      true # Jingle all the way
    end

    # Define properties. Properties return values for evaluation against operators.
    # No name transformation occurs. This is called using the "its" facility.
    # So this will be called as:
    #  describe "keycloak_realm" do
    #    its('shoe_size') { should cmp 42 }
    #  end
    def shoe_size
      # Implementation of a property specific to this resource
      42
    end

    def event_config
      # command = "/opt/keycloak/bin/kcadm.sh get events/config --no-config --server http://localhost:8080 --realm master --user admin --password admin"
      command = "#{@kcadm_path} get events/config -r #{@realm} --no-config --server http://localhost:8080 --realm master --user #{@keycloak_admin} --password #{@keycloak_admin_password}"
      # binding.pry
      inspec.json(content: inspec.command(command).stdout)
    end

    private

    # Methods to help the resource's public methods
    def helper_method
      # Add anything you need here
    end
  end
end
