Feature: PIM / Capio Test

  Background:
    * url capio_endpoint
    * def ItemIds = __arg.ItemId
    * def tenantId = account

  @ForVariantItem
  Scenario: Get product by itemID

    Given path "itemIds/" + ItemIds
    And param locale = "en-US"
    And header x-fabric-tenant-id = tenantId
    And header Authorization = auth
    When method get
    Then status 200
    And print response
    And assert response.variants[0].sku != null && response.variants[0].sku != ''
    And assert response.variants.length ==2

  @ForNonVariantItem
  Scenario: Get product by itemID

    Given path "itemIds/" + ItemIds
    And param locale = "en-US"
    And header x-fabric-tenant-id = tenantId
    And header Authorization = auth
    When method get
    Then status 200
    And print response
    And assert response.sku != null && response.sku != ''
    And assert response.itemId != null && response.itemId != ''


  @ForBundleItem
  Scenario: Get product by itemID
    Given path "itemIds/" + ItemIds
    And param locale = "en-US"
    And header x-fabric-tenant-id = tenantId
    And header Authorization = auth
    When method get
    Then status 200
    And print response
    And assert response.sku != null && response.sku != ''
    And assert response.itemId != null && response.itemId != ''
    And assert response.bundleProducts != null
    And assert response.type == "BUNDLE"
