# frozen_string_literal: true

def with_tenant(&block)
  ActsAsTenant.with_tenant(@tenant, &block)
end
