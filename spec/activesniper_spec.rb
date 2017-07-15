require 'spec_helper'

describe ActiveSniper do
  CALLBACKS = [
      { name: 'before_validation_snipe', params: { first_name: 'Jiro' }, method_name: :change_first_name },
      { name: 'after_validation_snipe', params: { last_name: 'Suzuki' }, method_name: :change_last_name },
      { name: 'around_save_snipe', params: { reason: 'Internet' }, method_name: :change_reason },
      { name: 'after_rollback_snipe', params: { company_name: 'NAKATA Inc.' }, method_name: :change_company_name },
      { name: 'before_save_snipe', params: { type_of_industry: 'Education' }, method_name: :change_type_of_industry },
      { name: 'after_save_snipe', params: { number_of_employees: 200 }, method_name: :change_number_of_employees },
      { name: 'before_update_snipe', params: { email: 'nakata@edu.ac.jp' }, method_name: :change_email },
      { name: 'after_update_snipe', params: { tel: '03-9876-5432' }, method_name: :change_tel },
      { name: 'around_update_snipe', params: { total_sales: 666_666_666 }, method_name: :change_total_sales },
      { name: 'after_commit_snipe', params: { admin: true }, method_name: :change_admin },
      {
        name: 'before_save_snipe',
        params: { first_name: 'Jiro', last_name: 'Suzuki', account_name: 'bar' },
        method_name: :change_except_columns
      }
  ]

  # TODO: ActiveRecord "save" or "create" fails when :arround_save or :arround_save_snipe is enabled.
  # let!(:user) do
  #   User.create(
  #       account_name: 'foo',
  #       first_name: 'Taro',
  #       last_name: 'Tanaka',
  #       company_name: 'TANAKA Inc.',
  #       type_of_industry: 'Logistics',
  #       number_of_employees: 100,
  #       reason: 'TV',
  #       email: 'tanaka@logitanaka.co.jp',
  #       tel: '03-1234-5678',
  #       total_sales: 365_000_000,
  #       admin: false
  #   )
  # end
  # TODO: As a workaround, after issuing SQL directly, "User.first" is executed.
  before do
    con = ActiveRecord::Base.connection
    con.execute(
        "INSERT INTO users(account_name, first_name, last_name, company_name, type_of_industry,\
                           number_of_employees, reason, email, tel, total_sales, admin, created_at, updated_at) \
         VALUES('foo', 'Taro', 'Tanaka', 'TANAKA Inc.', 'Logistics', 100, 'TV',\
                'tanaka@logitanaka.co.jp', '03-1234-5678', 365000000, 0, date('now'), date('now'))"
    )
  end
  let!(:user) { User.first }

  before do
    (User::METHOD_NAMES).each { |method_name| allow(user).to receive(method_name.to_sym) }
  end

  # TODO: Use Database Cleaner
  after { User.delete_all }

  subject { user }

  CALLBACKS.each do |callback|
    describe callback[:name] do
      before do
        user.update(params)
      end

      context 'launch callback' do
        let(:params) { callback[:params] }
        it { is_expected.to have_received(callback[:method_name]).once }
      end

      context 'do nothing' do
        let(:params) { { account_name: 'bar' } }
        it { is_expected.not_to have_received(callback[:method_name]) }
      end
    end
  end
end
