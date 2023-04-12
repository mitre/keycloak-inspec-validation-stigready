## EXAMPLE COMMANDS

$KEYCLOAK_HOME/bin/kcadm.sh get realms --fields realm,passwordPolicy --no-config --server http://localhost:8080 --realm master --user admin --password change_me

$KEYCLOAK_HOME/bin/kcadm.sh get events/config --no-config --server http://localhost:8080 --realm master --user admin --password change_me

opt/keycloak/bin/kcadm.sh get events/config -r master --no-config --server http://localhost:8080 --realm master --user admin --password change_me

## EXAMPLE FOR PLURAL RESOURCE USE
https://github.com/mitre/aws-foundations-cis-baseline/blob/master/controls/aws-foundations-cis-1.16.rb

translate ^ idea to realms
Use get realms to populate information on a plural realms resource
Do commands for each realm

- get realms
- get event info
- get-roles
- get authentication

Event config (use realm names to specify which realm, need to get realm names from outside [input or realms resource, etc])



## CONFIG FILES
12, 17, 18, 19, 21, 22, 23, 40, 55, 56, 57
parse_config_file('/opt/keycloak/conf/keycloak.conf')

## NOTES ON INDIVIDUAL CONTROL LOGIC
13. Add checks for events enabled
24. Manual check?
64. Manual check?
