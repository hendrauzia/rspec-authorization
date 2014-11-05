require 'rails_helper'

describe PostsController do
  it { is_expected.to have_permission_for(:user).to(:index) }
  it { is_expected.to have_permission_for(:user).to(:new) }
  it { is_expected.to have_permission_for(:user).to(:create) }
  it { is_expected.to have_permission_for(:user).to(:show) }
  it { is_expected.to have_permission_for(:user).to(:edit) }
  it { is_expected.to have_permission_for(:user).to(:update) }
  it { is_expected.to have_permission_for(:user).to(:destroy) }
end
