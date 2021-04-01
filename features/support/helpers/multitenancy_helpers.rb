# frozen_string_literal: true

def with_tenant
  ActsAsTenant.with_tenant(@tenant, &block)
end
