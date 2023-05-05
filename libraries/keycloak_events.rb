module Inspec::Resources

  class Keycloak_Events < Keycloak
    name "keycloak_events"

    def initialize(realm)
      super()
      @realm = realm
    end

    FilterTable.create
      .register_column(:clientId, field: :clientId)
      .register_column(:ipAddress, field: :ipAddress)
      .register_column(:type, field: :type)
      .register_column(:time, field: :time)
      .register_column(:userId, field: :userId)
      .register_column(:realmId, field: :realmId)
      .register_column(:sessionId, field: :sessionId)
      .register_column(:details, field: :details)
      .install_filter_methods_on_resource(self, :fetch_data)
    
    def to_s
      "Keyclock Events"
    end

    def fetch_data
      rows = []
      command = "#{@kcadm_path} get events -r #{@realm} #{no_config_settings}"
      results = inspec.json(command: command)
      results.each do |line|
        rows+=[{ clientId: line["clientId"], ipAddress: line['ipAddress'], type: line['type'], time: line['time'], userId: line['userId'], realmId: line['realmId'], sessionId: line['sessionId'], details: line['details']}]
      end
      @table = rows
    end

  end
end