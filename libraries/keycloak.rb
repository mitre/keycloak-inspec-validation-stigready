
module Inspec::Resources

  class Keycloak < Inspec.resource(1)
    name "keycloak"

    supports platform: "unix"
    supports platform: "windows"

    desc "keycloak Resource to gather environment variables then create the kcadm commands required for running inspec profile"

    example <<~EXAMPLE
      describe "keycloak" do
        its("shoe_size") { should cmp 10 }
      end
      describe "keycloak" do
        it { should be_purple }
      end
    EXAMPLE

    # Resource initialization. Add any arguments you want to pass to the contructor here.
    # Anything you pass here will be passed to the "describe" call:
    # describe keycloak(YOUR_PARAMETERS_HERE) do
    #   its("shoe_size") { should cmp 10 }
    # end
    def initialize()
      # Initialize required path/params/configs
      keycloak_home = inspec.os_env("KEYCLOAK_HOME").content
      keycloak_admin = inspec.os_env("KEYCLOAK_ADMIN").content
      keycloak_admin_password = inspec.os_env("KEYCLOAK_ADMIN_PASSWORD").content
      if keycloak_admin.nil? || keycloak_admin.empty?
        raise Inspec::Exceptions::ResourceFailed, 'Failing because $KEYCLOAK_ADMIN env value not set or empty in the system'
      end

      if keycloak_admin_password.nil? || keycloak_admin_password.empty?
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
          @no_config_settings = "--no-config --server http://localhost:8080 --realm master --user #{keycloak_admin} --password #{keycloak_admin_password}"
        end
      end
      # skip_resource "The `keycloak` resource is not yet available on your OS." unless inspec.os.os?
    end

    # TODO may need to figure out how to pass --server and --realm variables instead of hardcoded

    def event_config(realm)
      command = "#{@kcadm_path} get events/config -r #{realm} #{@no_config_settings}"
      inspec.json(command: command)
    end

    def get_realms
      command = "#{@kcadm_path} get realms #{@no_config_settings}"
      inspec.json(command: command)
    end

    def get_realm_info(realm)
      command = "#{@kcadm_path} get realms/#{realm} #{@no_config_settings}"
      inspec.json(command: command)
    end
  end
end
