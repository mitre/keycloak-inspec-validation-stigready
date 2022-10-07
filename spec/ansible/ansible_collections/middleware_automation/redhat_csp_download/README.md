# redhat_csp_download Collection for Ansible

[![Build Status](https://github.com/ansible-middleware/redhat-csp-download/workflows/CI/badge.svg?branch=main)](https://github.com/ansible-middleware/redhat-csp-download/actions?workflow=CI)

Collection to download resources from the Red Hat Customer Portal.

<!--start requires_ansible-->
## Ansible version compatibility

This collection has been tested against following Ansible versions: **>=2.9.10**.

Plugins and modules within a collection may be tested with only specific Ansible versions. A collection may contain metadata that identifies these versions.
<!--end requires_ansible-->

## Included content

Click on the name of a plugin or module to view that content's documentation:

### Modules
Name | Description
--- | ---
redhat_csp_download|Download resources from the Red Hat Customer Portal.

### Roles
Name | Description
--- | ---
redhat_csp_download|Installs necessary dependencies required by the redhat_csp_download module.

## Installation and Usage

### Installing the Collection from Ansible Galaxy

Before using the collection, you need to install it with the Ansible Galaxy CLI:

    ansible-galaxy collection install middleware_automation.redhat_csp_download

You can also include it in a `requirements.yml` file and install it via `ansible-galaxy collection install -r requirements.yml`, using the format:

```yaml
---
collections:
  - name: middleware_automation.redhat_csp_download
```
### Using via GitHub Action
A GitHub action which is uses this role is provided by the Red Hat Containers Community of Practice (CoP)
- https://github.com/redhat-cop/github-actions/tree/master/redhat-csp-download

## License

Apache License v2.0 or later

See [LICENCE](LICENSE) to view the full text.


