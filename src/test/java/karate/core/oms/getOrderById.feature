Feature: Get Order By Order ID

  Background:
    * url omsV2_endpoint
    * def orderId = __arg.orderId
    * def tenantId = account
    * def channelId = channel

    @GetOrderForSingleLineItem
  Scenario: Get Order By Order Id
    Given path 'orders/' + orderId
    And header  x-fabric-tenant-id = tenantId
    And header  x-fabric-channel-id = channelId
    And header Authorization = auth
    And header Content-Type = 'application/json'
    When method get
    Then status 200
    And print response
    And assert response.orderId == __arg.orderId
    And assert response.orderNumber != null && response.orderNumber != ''
    And assert response.statusCode == "ORDER_CREATED" || response.statusCode == "ORDER_HOLD"
    And assert response.payments.length > 0
    And assert response.items.length == 1


  @GetOrderForMultiLineItem
  Scenario: Get Order By Order Id
    Given path 'orders/' + orderId
    And header  x-fabric-tenant-id = tenantId
    And header  x-fabric-channel-id = 12
    And header Authorization = auth
    And header Content-Type = 'application/json'
    And header Authorization = auth
    When method get
    Then status 200
    And print response
    And assert response.orderId == __arg.orderId
    And assert response.orderNumber != null && response.orderNumber != ''
    And assert response.statusCode == "ORDER_CREATED" || response.statusCode == "ORDER_HOLD"
    And assert response.payments.length > 0
    And assert response.items.length == 2