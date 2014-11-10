require 'rails_helper'

describe ArticlesController do
  it { is_expected.to have_permission_for(:user).to(:index) }
  it { is_expected.to have_permission_for(:user).to(:show) }
  it { is_expected.not_to have_permission_for(:user).to(:new) }
  it { is_expected.not_to have_permission_for(:user).to(:create) }
  it { is_expected.not_to have_permission_for(:user).to(:edit) }
  it { is_expected.not_to have_permission_for(:user).to(:update) }
  it { is_expected.not_to have_permission_for(:user).to(:destroy) }

  it { is_expected.to have_permission_for(:writer).to(:index) }
  it { is_expected.to have_permission_for(:writer).to(:show) }
  it { is_expected.to have_permission_for(:writer).to(:new) }
  it { is_expected.to have_permission_for(:writer).to(:create) }
  it { is_expected.not_to have_permission_for(:writer).to(:edit) }
  it { is_expected.not_to have_permission_for(:writer).to(:update) }
  it { is_expected.not_to have_permission_for(:writer).to(:destroy) }

  it { is_expected.to have_permission_for(:editor).to(:index) }
  it { is_expected.to have_permission_for(:editor).to(:show) }
  it { is_expected.to have_permission_for(:editor).to(:new) }
  it { is_expected.to have_permission_for(:editor).to(:create) }
  it { is_expected.to have_permission_for(:editor).to(:edit) }
  it { is_expected.to have_permission_for(:editor).to(:update) }
  it { is_expected.to have_permission_for(:editor).to(:destroy) }
end
