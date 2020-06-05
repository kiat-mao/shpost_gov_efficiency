require "application_system_test_case"

class ExpressesTest < ApplicationSystemTestCase
  setup do
    @express = expresses(:one)
  end

  test "visiting the index" do
    visit expresses_url
    assert_selector "h1", text: "Expresses"
  end

  test "creating a Express" do
    visit expresses_url
    click_on "New Express"

    click_on "Create Express"

    assert_text "Express was successfully created"
    click_on "Back"
  end

  test "updating a Express" do
    visit expresses_url
    click_on "Edit", match: :first

    click_on "Update Express"

    assert_text "Express was successfully updated"
    click_on "Back"
  end

  test "destroying a Express" do
    visit expresses_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Express was successfully destroyed"
  end
end
