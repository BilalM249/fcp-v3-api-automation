Feature: Price v2 RTPE


  Background:
    * url rtpe_endpoint
    * def priceListId = PRICE_LIST_ID
    * def payloadMultiItem = {"priceListId": '#(priceListId)', "itemIds": ['#(__arg.ItemId1)','#(__arg.ItemId2)']}
    * def payloadSingleItem = {"priceListId": '#(priceListId)', "itemIds": ['#(__arg.ItemId)']}
    * def tenantId = account
    * def channelId = channel



  @PriceFor2Items
  Scenario: Get Price
    Given path 'evaluate-products-by-id'
    And header x-fabric-tenant-id = tenantId
    And header x-fabric-channel-id = channelId
    And header Content-type = 'application/json'
    And request payloadMultiItem
    And header Authorization = auth
    When method post
    Then status 200
    And print response
    And assert response.data.length == 2
    And assert response.data[0].offer.price.base != null &&  response.data[0].offer.price.base != ''
    And assert response.data[1].offer.price.base != null &&  response.data[1].offer.price.base != ''

  @PriceForSingleItems
  Scenario: Get Price
    Given path 'evaluate-products-by-id'
    And header x-fabric-tenant-id = tenantId
    And header x-fabric-channel-id = '12'
    And header Content-type = 'application/json'
    And request payloadSingleItem
    And header Authorization = auth
    When method post
    Then status 200
    And print response
    And assert response.data.length == 1
    And assert response.data[0].offer.price.base != null &&  response.data[0].offer.price.base != ''

  @ForNon_PriceItem
  Scenario: Get Price
    Given path 'evaluate-products-by-id'
    And header x-fabric-tenant-id = tenantId
    And header x-fabric-channel-id = '12'
    And header Content-type = 'application/json'
    And request payloadSingleItem
    And header Authorization = auth
    When method post
    Then status 207
    And print response
    And assert response.errors[0].type == "NOT_FOUND"
    And assert response.data.length == 0