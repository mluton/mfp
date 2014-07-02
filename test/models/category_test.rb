require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  test "category attributes should not be empty" do
    category = Category.new
    assert category.invalid?
    assert category.errors[:name].any?
    assert_includes category.errors[:name], "can't be blank"
  end

  test "ordinal is a positive integer" do
    good = [1, 2, 3, 99999]
    bad = [-1, 0, 1.5]

    category = categories(:getting_started)

    good.each do |ordinal|
      category.ordinal = ordinal
      assert category.valid?
    end

    bad.each do |ordinal|
      category.ordinal = ordinal
      assert category.invalid?
      assert category.errors[:ordinal].any?
    end
  end

  test "ordered scope returns categories in order" do
    categories = Category.ordered
    assert_equal categories[0].ordinal, 1
    assert_equal categories[1].ordinal, 2
    assert_equal categories[2].ordinal, 3
    assert_equal categories[3].ordinal, 4
  end
end
