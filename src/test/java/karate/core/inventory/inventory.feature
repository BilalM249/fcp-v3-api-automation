Feature: Inventory v2

  Background:

    * url omsV2_endpoint
    * def payload = {"sort": "-inventory.createdAt","filters": [{"field": "inventory.sku","value": '#(__arg.sku)',"condition": "EQ"}]}
    * def tenantId = account
    * def channel = channel

    @InventoryConfigured
  Scenario: Get Inventory by SKU and network Code
    Given path 'inventories/search'
    And header x-fabric-tenant-id = tenantId
    And header x-fabric-channel-id = channel
    And header Authorization = auth
    And request payload
    When method post
    Then status 200
    And print response
    And assert response.data.length >0
    And assert response.data[0].counters.onHand > 0

  @ForNon_InventoryItem
  Scenario: Get Inventory by SKU and network Code
    Given path 'inventories/search'
    And header x-fabric-tenant-id = tenantId
    And header x-fabric-channel-id = channel
    And header Authorization = auth
    And request payload
    When method post
    Then status 200
    And print response
    And assert response.pagination.count == 0
    And assert response.data.length == 0



