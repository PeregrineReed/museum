require 'minitest/autorun'
require 'minitest/pride'
require './lib/exhibit'
require './lib/patron'
require './lib/museum'

class MuseumTest < Minitest::Test

  def setup
    @dmns = Museum.new("Denver Museum of Nature and Science")

    @gems_and_minerals = Exhibit.new("Gems and Minerals", 0)
    @dead_sea_scrolls = Exhibit.new("Dead Sea Scrolls", 10)
    @imax = Exhibit.new("IMAX", 15)

    @bob = Patron.new("Bob", 20)
    @sally = Patron.new("Sally", 20)
    @tj = Patron.new("TJ", 7)
  end

  def test_it_exists
    assert_instance_of Museum, @dmns
  end

  def test_it_has_a_name
    museum = "Denver Museum of Nature and Science"

    assert_equal museum, @dmns.name
  end

  def test_it_starts_with_no_exhibits
    assert_equal [], @dmns.exhibits
  end

  def test_it_can_add_exhibits
    @dmns.add_exhibit(@gems_and_minerals)
    @dmns.add_exhibit(@dead_sea_scrolls)
    @dmns.add_exhibit(@imax)

    exhibits = [
      @gems_and_minerals,
      @dead_sea_scrolls,
      @imax
    ]

    assert_equal exhibits, @dmns.exhibits
  end

  def test_it_starts_with_no_patrons
    assert_equal [], @dmns.patrons
  end

  def test_it_can_admit_patrons
    @dmns.admit(@bob)
    @dmns.admit(@sally)

    assert_equal [@bob, @sally], @dmns.patrons
  end

  def test_it_can_recommend_exhibits
    @dmns.add_exhibit(@gems_and_minerals)
    @dmns.add_exhibit(@dead_sea_scrolls)
    @dmns.add_exhibit(@imax)
    @bob.add_interest("Dead Sea Scrolls")
    @bob.add_interest("Gems and Minerals")
    @sally.add_interest("IMAX")

    recommended_for_bob = [
      @gems_and_minerals,
      @dead_sea_scrolls
    ]

    recommend_for_sally = [
      @imax
    ]

    assert_equal recommended_for_bob, @dmns.recommend_exhibits(@bob)
    assert_equal recommend_for_sally, @dmns.recommend_exhibits(@sally)
  end

  def test_it_can_list_patrons_by_exhibit_interest
    @dmns.add_exhibit(@gems_and_minerals)
    @dmns.add_exhibit(@dead_sea_scrolls)
    @dmns.add_exhibit(@imax)
    @bob.add_interest("Dead Sea Scrolls")
    @bob.add_interest("Gems and Minerals")
    @sally.add_interest("Dead Sea Scrolls")
    @dmns.admit(@bob)
    @dmns.admit(@sally)

    patron_exhibit_interests = {
      @gems_and_minerals => [@bob],
      @dead_sea_scrolls => [@bob, @sally],
      @imax => []
    }

    assert_equal patron_exhibit_interests, @dmns.patrons_by_exhibit_interest
  end

  def test_patrons_attend_affordable_exhibits
    @dmns.add_exhibit(@gems_and_minerals)
    @dmns.add_exhibit(@imax)
    @dmns.add_exhibit(@dead_sea_scrolls)
    @tj.add_interest("IMAX")
    @tj.add_interest("Dead Sea Scrolls")

    @dmns.admit(@bob)
    @dmns.admit(@tj)

    assert_equal 7, @tj.spending_money
  end

  def test_patrons_view_the_most_expensive_exhibit
    @dmns.add_exhibit(@gems_and_minerals)
    @dmns.add_exhibit(@imax)
    @dmns.add_exhibit(@dead_sea_scrolls)
    @bob.add_interest("Dead Sea Scrolls")
    @bob.add_interest("IMAX")

    @dmns.admit(@bob)
    
    assert_equal 0, @bob.spending_money
  end

end
