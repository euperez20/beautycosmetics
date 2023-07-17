require "test_helper"

class ProductColorsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @product_color = product_colors(:one)
  end

  test "should get index" do
    get product_colors_url
    assert_response :success
  end

  test "should get new" do
    get new_product_color_url
    assert_response :success
  end

  test "should create product_color" do
    assert_difference("ProductColor.count") do
      post product_colors_url, params: { product_color: { color_id: @product_color.color_id, product_id: @product_color.product_id } }
    end

    assert_redirected_to product_color_url(ProductColor.last)
  end

  test "should show product_color" do
    get product_color_url(@product_color)
    assert_response :success
  end

  test "should get edit" do
    get edit_product_color_url(@product_color)
    assert_response :success
  end

  test "should update product_color" do
    patch product_color_url(@product_color), params: { product_color: { color_id: @product_color.color_id, product_id: @product_color.product_id } }
    assert_redirected_to product_color_url(@product_color)
  end

  test "should destroy product_color" do
    assert_difference("ProductColor.count", -1) do
      delete product_color_url(@product_color)
    end

    assert_redirected_to product_colors_url
  end
end
