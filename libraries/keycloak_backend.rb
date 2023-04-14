require 'pry'

class KeycloakConnection
  def initialize
    # binding.pry
    # Initialize required path/params/configs
    keycloak_home = inspec.os_env("KEYCLOAK_HOME").content
    @keycloak_admin = inspec.os_env("KEYCLOAK_ADMIN").content
    @keycloak_admin_password = inspec.os_env("KEYCLOAK_ADMIN_PASSWORD").content
    # binding.pry
    if @keycloak_admin.nil? || @keycloak_admin.empty?
      raise Inspec::Exceptions::ResourceFailed, 'Failing because $KEYCLOAK_ADMIN env value not set or empty in the system'
    end

    if @keycloak_admin_password.nil? || keycloak_admin_password.empty?
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
    # test_command = "#{@kcadm_path} config credentials --server #{keycloak_server} -r #{keycloak_realm} --password #{keycloak_admin_password}"
    # skip_resource "The `keycloak` resource is not yet available on your OS." unless inspec.os.os?
  end

  def get_realms
    command = "#{@kcadm_path} get realms --no-config --server http://localhost:8080 --realm master --user #{@keycloak_admin} --password #{@keycloak_admin_password}"
    # binding.pry
    inspec.json(content: inspec.command(command).stdout)
  end
end

class Keycloak < Inspec.resource(1)
  # Every resource requires an internal name.
  name "keycloak"

  # Restrict to only run on the below platforms (if none were given,
  # all OS's and cloud API's supported)
  supports platform: "unix"
  supports platform: "windows"

  desc "keycloak admin configuration"

  example <<~EXAMPLE
    describe "keycloak" do
      its("shoe_size") { should cmp 10 }
    end
    describe "keycloak" do
      it { should be_purple }
    end
  EXAMPLE

  attr_reader :keycloak

  def initialize
    # binding.pry
    @keycloak = KeycloakConnection.new()
  end
end