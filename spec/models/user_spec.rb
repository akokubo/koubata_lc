require 'spec_helper'

describe User do
  # 事前に作成するユーザー
  before do
    @user = User.new(
      email: "user@example.com",
      password: "foobarfoobar",
      password_confirmation: "foobarfoobar"
    )
  end

  # ユーザーに関するテストを実施する
  subject { @user }

  # email属性を持つ
  it { should respond_to(:email) }
  # passwordとpassword_confirmation属性を持つ
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }

  # 検証に通る
  it { should be_valid }

  # email属性が空の場合
  describe "when email is not present" do
    before { @user.email = " " }
    it { should_not be_valid }
  end

  # 適正なメールアドレスの場合
  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        expect(@user).to be_valid
      end      
    end
  end

  # emailが既に使われていた場合
  describe "when email address already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end

    it { should_not be_valid }
  end

  # emailの大文字を小文字に変換して保存しているか
  describe "email address with mixed case" do
    let(:mixed_case_email) { "Foo@ExAMPle.CoM" }

    it "should be saved as all lower-case" do
      @user.email = mixed_case_email
      @user.save
      expect(@user.reload.email).to eq mixed_case_email.downcase
    end
  end

  # パスワードが空の場合
  describe "when password is not present" do
    before do
      @user = User.new(
        email: "user@example.com",
        password: " ",
        password_confirmation: " "
      )
    end
    it { should_not be_valid }
  end

  # パスワードとパスワード(確認)が一致しない場合
  describe "when password dosen't match confirmation" do
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end

  # パスワードが7文字以下の場合
  describe "with a password that's too short" do
    before { @user.password = @user.password_confirmation = "a" * 7 }
    it { should be_invalid }
  end
end
