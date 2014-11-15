require 'rails_helper'

describe ArticlesController do
  it { is_expected.to have_permission_for(:user).to(:index) }
  it { is_expected.not_to have_permission_for(:user).to(:show) }
  it { is_expected.not_to have_permission_for(:user).to_create }
  it { is_expected.not_to have_permission_for(:user).to_update }
  it { is_expected.not_to have_permission_for(:user).to_delete }

  it { is_expected.to have_permission_for(:premium).only_to_read }
  it { is_expected.to have_permission_for(:writer ).except_to_delete }
  it { is_expected.to have_permission_for(:editor ).to_manage }
end
