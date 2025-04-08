# app/policies/order_policy.rb
class OrderPolicy < ApplicationPolicy
    def index?
      user.is_a?(Customer) || user.is_a?(BusinessAdmin) || user.is_a?(StoreManager)
    end
  
    def show?
      user.is_a?(Customer) && record.customer == user ||
      user.is_a?(BusinessAdmin) && record.store.business_admin == user ||
      user.is_a?(StoreManager) && record.store.store_manager == user
    end
  
    # outras regras conforme necessário
end