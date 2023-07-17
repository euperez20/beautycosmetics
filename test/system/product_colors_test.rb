require "application_system_test_case"

class ProductColorsTest < ApplicationSystemTestCase
  setup do
    @product_color = product_colors(:one)
  end

  test "visiting the index" do
    visit product_colors_url
    assert_selector "h1", text: "Product colors"
  end

  test "should create product color" do
    visit product_colors_url
    click_on "New product color"

    fill_in "Color", with: @product_color.color_id
    fill_in "Product", with: @product_color.product_id
    click_on "Create Product color"

    assert_text "Product color was successfully created"
    click_on "Back"
  end

  test "should update Product color" do
    visit product_color_url(@product_color)
    click_on "Edit this product color", match: :first

    fill_in "Color", with: @product_color.color_id
    fill_in "Product", with: @product_color.product_id
    click_on "Update Product color"

    assert_text "Product color was successfully updated"
    click_on "Back"
  end

  test "should destroy Product color" do
    visit product_color_url(@product_color)
    click_on "Destroy this product color", match: :first

    assert_text "Product color was successfully destroyed"
  end
end
