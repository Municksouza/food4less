module CustomersHelper
    def dynamic_customer_path(customer)
      customer_path(customer) 
    end
  
    def dynamic_customers_index_path
      customers_path 
    end
  end