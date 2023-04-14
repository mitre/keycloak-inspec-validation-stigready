+++
title = "keycloak_realms resource"
draft = false
gh_repo = "inspec"
platform = "linux"

[menu]
  [menu.inspec]
    title = "keycloak_realms"
    identifier = "inspec/resources/os/keycloak_realms.md keycloak_realms resource"
    parent = "inspec/resources/os"
+++

Use the `keycloak_realms` Chef InSpec audit resource to test multiple ...


## Availability

### Installation

This resource is distributed along with Chef InSpec itself. You can use it automatically.

## Syntax

A `keycloak_realms` Chef InSpec audit resource tests multiple ...

    describe keycloak_realms.where { shoe_size > 10 } do
      its('count') { should cmp 10 }
    end

where

- `'shoe_size'` is a filter criteria of this resource
- `10` is the value to test for shoe size
- `count` is the count of matched records

## Filter Criteria

### shoe_size

The shoe_size filter criteria tests ....

## Properties

### count

Returns the number of records matched by the filter criteria.

    describe keycloak_realms.where { shoe_size > 10 } do
      its('count') { should cmp 10 }
    end

## Matchers

### exist

The control will pass if the filter returns at least one result. Use
`should_not` if you expect zero matches.

    describe keycloak_realms do
      it { should exist }
    end
