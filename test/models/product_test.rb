require "test_helper"

class ProductTest < ActiveSupport::TestCase
  fixtures :products

  test "product attributes must not be empty" do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:image_url].any?
    assert product.errors[:price].any?
    assert product.errors[:description].any?
  end

  test "product price must be positive" do
    product = Product.new(title: "title", description: "yyy", image_url: "zzz.jpg")

    product.price = -1
    assert product.invalid?
    assert_equal ['must be greater than or equal to 0.01'], product.errors[:price]

    product.price = 1
    assert product.valid?
  end


  def new_product(image_url)
    Product.new(title: "title", description: "yyy", image_url: image_url, price: 1)
  end
  
  test "image url" do
    ok = %w{ fred.gif fred.jpg fred.png .png}
    bad = %w{ fred.docs fred.beskarfox}

    ok.each do |image_url|
      assert new_product(image_url).valid?, "#{image_url} must be valid"
    end

    bad.each do |image_url|
      assert new_product(image_url).invalid?, "#{image_url} must be invalid"
    end
    assert true
  end

  test "product is not vqlid without a unique title" do
    product = Product.new(title: products(:one).title, description: "rf", price: 1, image_url: "fe")
    assert product.invalid?
  end
end
