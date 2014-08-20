require 'rails_helper'

describe Category do
  # 事前に@categoryを作成する
  before { @category = Category.new(name: "宿泊・賃貸住宅") }

  # @categoryをテストの対象とする
  subject { @category }

  # name属性を持っている
  it { should respond_to(:name) }

  # 検証を通過する
  it { should be_valid }

  # name属性が存在しない場合
  describe "when name is not present" do
    # name属性を空に
    before { @category.name = " " }

    # 検証を通過しない
    it { should_not be_valid }
  end

  # 同じname属性を持ったデータが存在していた場合
  describe "when name is already taken" do
    # 事前に同じname属性を持ったデータを用意し、保存を試みる
    before do
      category_with_same_name = @category.dup
      category_with_same_name.save
    end

    # 検証を通過しない
    it { should_not be_valid }
  end
end