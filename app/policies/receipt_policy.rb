class ReceiptPolicy < ApplicationPolicy
  def show?
    return false unless user

    super_admin_access? || business_admin_access? || store_manager_access? || customer_access?
  end

  def index?
    user.is_a?(BusinessAdmin) || user.is_a?(SuperAdmin) || user.is_a?(StoreManager)
  end

  private

  def super_admin_access?
    user.is_a?(SuperAdmin)
  end

  def business_admin_access?
    user.is_a?(BusinessAdmin) && record.store.business_admin_id == user.id
  end

  def store_manager_access?
    user.is_a?(StoreManager) && user.store_id == record.store_id
  end

  def customer_access?
    user.is_a?(Customer) && record.order&.customer_id == user.id
  end
end