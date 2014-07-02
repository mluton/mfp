require 'test_helper'

# http://mattsears.com/articles/2011/12/10/minitest-quick-reference

class ArticleTest < ActiveSupport::TestCase

  test "good article passes validation" do
    article = articles(:what_is_minecraft)
    assert article.valid?
  end

  test "article attributes should not be empty" do
    article = Article.new
    assert article.invalid?
    assert article.errors[:title].any?
    assert_includes article.errors[:title], "can't be blank"
    assert article.errors[:description].any?
    assert_includes article.errors[:description], "can't be blank"
    assert article.errors[:body].any?
    assert_includes article.errors[:body], "can't be blank"
  end

  test "description is the right length" do
    good = [
      # 10 characters; exact minimum
      "abcdefghij",
      # 11 characters; miminum +1
      "abcdefghijk",
      # 499 characters: maximum -1
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed tristique magna metus, a porttitor erat feugiat nec. Integer iaculis nunc et mi iaculis scelerisque. Vivamus laoreet erat tincidunt, iaculis ligula viverra, imperdiet nulla. Etiam ac velit a nunc sagittis dapibus. In pulvinar purus non purus semper, nec fermentum risus feugiat. Praesent id dictum mi, et imperdiet libero. Curabitur sodales enim nec orci malesuada, sed mollis lectus iaculis. Donec sem mauris, accumsan in enim eu, tincx",
      # 500 characters: exact maximum
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed tristique magna metus, a porttitor erat feugiat nec. Integer iaculis nunc et mi iaculis scelerisque. Vivamus laoreet erat tincidunt, iaculis ligula viverra, imperdiet nulla. Etiam ac velit a nunc sagittis dapibus. In pulvinar purus non purus semper, nec fermentum risus feugiat. Praesent id dictum mi, et imperdiet libero. Curabitur sodales enim nec orci malesuada, sed mollis lectus iaculis. Donec sem mauris, accumsan in enim eu, tincixx"
    ]

    too_short = [
      # none
      "",
      # one
      "a",
      # 9 characters; minimum -1
      "abcdefghi"
    ]

    too_long = [
      # 501 characters; maximum +1
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed tristique magna metus, a porttitor erat feugiat nec. Integer iaculis nunc et mi iaculis scelerisque. Vivamus laoreet erat tincidunt, iaculis ligula viverra, imperdiet nulla. Etiam ac velit a nunc sagittis dapibus. In pulvinar purus non purus semper, nec fermentum risus feugiat. Praesent id dictum mi, et imperdiet libero. Curabitur sodales enim nec orci malesuada, sed mollis lectus iaculis. Donec sem mauris, accumsan in enim eu, tincixxx"
    ]

    article = articles(:what_is_minecraft)

    good.each do | description |
      article.description = description
      assert article.valid?
    end

    too_short.each do |description|
      article.description = description
      assert article.invalid?
      assert article.errors[:description].any?
      assert_includes article.errors[:description], "is too short (minimum is 10 characters)"
    end

    too_long.each do |description|
      article.description = description
      assert article.invalid?
      assert article.errors[:description].any?
      assert_includes article.errors[:description], "is too long (maximum is 500 characters)"
    end
  end

  test "ordinal is a positive integer" do
    good = [1, 2, 3, 99999]
    bad = [-1, 0, 1.5]

    article = articles(:what_is_minecraft)

    good.each do |ordinal|
      article.ordinal = ordinal
      assert article.valid?
    end

    bad.each do |ordinal|
      article.ordinal = ordinal
      assert article.invalid?
      assert article.errors[:ordinal].any?
    end
  end

  test "category association works" do
    assert articles(:what_is_minecraft).category
  end

  test "next and previous methods" do
    assert_nil articles(:first).previous
    assert_equal articles(:first).next.ordinal, 2
    assert_equal articles(:third).previous.ordinal, 2
    assert_nil articles(:third).next
  end

end
