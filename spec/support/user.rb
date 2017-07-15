class User < ActiveRecord::Base
  METHOD_NAMES = [
      'change_first_name',
      'change_last_name',
      'change_company_name',
      'change_type_of_industry',
      'change_number_of_employees',
      'change_reason',
      'change_email',
      'change_tel',
      'change_total_sales',
      'change_admin',
      'change_except_columns'
  ]

  validates :first_name, presence: true
  validates :last_name, presence: true

  before_validation_snipe :change_first_name, only: :first_name
  after_validation_snipe :change_last_name, only: :last_name
  after_rollback_snipe :change_company_name, only: :company_name
  before_save_snipe :change_type_of_industry, only: :type_of_industry
  after_save_snipe :change_number_of_employees, only: :number_of_employees
  around_save_snipe :change_reason, only: :reason
  before_update_snipe :change_email, only: :email
  after_update_snipe :change_tel, only: :tel
  around_update_snipe :change_total_sales, only: :total_sales
  after_commit_snipe :change_admin, only: :admin
  before_save_snipe :change_except_columns, except: [
      :company_name, :type_of_industry, :number_of_employees,
      :reason, :email, :tel, :total_sales, :admin
  ]

  METHOD_NAMES.each do |method_name|
    define_method method_name do
    end
  end
end
